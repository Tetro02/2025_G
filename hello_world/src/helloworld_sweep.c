// ========== 2025_G 扫频测试 ==========
// DDS→DAC→被测电路→ADC1(响应), ADC2(参考)
// H(f)=ADC1/ADC2, 输出CSV

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#define ARM_MATH_CA9
#define __FPU_PRESENT 1U
#include "xparameters.h"
#include "xil_io.h"
#include "xscugic.h"
#include "xil_exception.h"

#define FFT_LENGTH   4096
#define SAMPLE_FREQ  299401.1976047f
#define ADC_BIAS     2048.0f
#define SWEEP_POINTS 2048
#define SWEEP_STEP   244.140625f
#define SWEEP_START  SWEEP_STEP

#define SMOOTH_WINDOW   15
#define LOCAL_WINDOW    10
#define LOCAL_THRESHOLD 15.0f

#define CTRL_BIT_ADC_SAMPLE (1<<0)
#define CTRL_BIT_FIR_COEF   (1<<1)
#define CTRL_BIT_DDS        (1<<2)
#define CTRL_BIT_FIR_DAC    (1<<3)
#define CTRL_BIT_CAL        (1<<4)

#define BRAM_ADDR XPAR_AXI_BRAM_CTRL_0_BASEADDR
#define LITE_ADDR XPAR_AXI_LITE_PS_TO_PL_PL_0_BASEADDR
#define CTRL_REG  (LITE_ADDR+0x00)
#define DDS_FREQ  (LITE_ADDR+0x04)
#define DDS_CTRL  (LITE_ADDR+0x08)

#define DDS_CLK      50000000.0f
#define DDS_PHASE_B  28
#define DDS_WAVE_SIN 0

#define INTC_DEVICE XPAR_SCUGIC_SINGLE_DEVICE_ID
#define PL_IRQ      61

XScuGic Intc;
static volatile int adc_ready=0;
static uint16_t buf_ch1[FFT_LENGTH], buf_ch2[FFT_LENGTH];
static float freq_arr[SWEEP_POINTS], ch1_amp_arr[SWEEP_POINTS], ch1_phase_arr[SWEEP_POINTS];
static float ch2_amp_arr[SWEEP_POINTS], ch2_phase_arr[SWEEP_POINTS];
static float H_amp_arr[SWEEP_POINTS], H_phase_arr[SWEEP_POINTS];
static float H_amp_out[SWEEP_POINTS], H_phase_out[SWEEP_POINTS];

static const float PI=3.14159265358979f;
static float fast_cosf(float x){
    x=x-((int)(x/(2.0f*PI)))*(2.0f*PI);
    if(x>PI)x=2.0f*PI-x;
    float x2=x*x;
    return 1.0f-x2/2.0f+x2*x2/24.0f-x2*x2*x2/720.0f;
}
static float fast_sinf(float x){return fast_cosf(x-PI/2.0f);}

static float local_median(float*arr,int center,int W){
    float vals[41]; int n=0;
    for(int j=center-W;j<=center+W;j++){
        if(j>=0&&j<SWEEP_POINTS)vals[n++]=arr[j];
    }
    for(int a=0;a<n-1;a++)
        for(int b=a+1;b<n;b++)
            if(vals[a]>vals[b]){float t=vals[a];vals[a]=vals[b];vals[b]=t;}
    return vals[n/2];
}

typedef struct{float I,Q;}IQ_Raw;
IQ_Raw iq_demodulate_raw(const uint16_t*s,float fhz,float fs,uint32_t N){
    float I=0,Q=0,om=2.0f*PI*fhz/fs,pa=0;
    for(uint32_t n=0;n<N;n++){
        float v=(float)s[n]-ADC_BIAS;
        I+=v*fast_cosf(pa); Q+=v*fast_sinf(pa);
        pa+=om; if(pa>=2.0f*PI)pa-=2.0f*PI;
    }
    IQ_Raw r; r.I=I; r.Q=Q; return r;
}

void set_ctrl(uint32_t f){Xil_Out32(CTRL_REG,f&0x1F);}
void set_dds(float fhz){
    uint32_t fw=(uint32_t)(fhz*(float)(1u<<DDS_PHASE_B)/DDS_CLK+0.5f);
    if(fw>0x0FFFFFFF)fw=0x0FFFFFFF;
    Xil_Out32(DDS_FREQ,fw);
    Xil_Out32(DDS_CTRL,(255<<13)|(DDS_WAVE_SIN<<11)|0);
}
void read_bram(void){
    for(int i=0;i<FFT_LENGTH;i++){
        buf_ch1[i]=Xil_In16(BRAM_ADDR+i*4);
        buf_ch2[i]=Xil_In16(BRAM_ADDR+i*4+2);
    }
}
void delay_us(uint32_t us){for(volatile uint32_t i=0;i<us*166;i++);}

void remove_phase_outliers(void){
    static int is_bad[SWEEP_POINTS]; int W=LOCAL_WINDOW;
    for(int i=0;i<SWEEP_POINTS;i++){
        float med=local_median(H_phase_arr,i,W);
        is_bad[i]=(fabsf(H_phase_arr[i]-med)>LOCAL_THRESHOLD)?1:0;
    }
    for(int i=0;i<SWEEP_POINTS;i++){
        if(!is_bad[i]){H_phase_out[i]=H_phase_arr[i];continue;}
        int left=-1,right=-1;
        for(int j=i-1;j>=0;j--){if(!is_bad[j]){left=j;break;}}
        for(int j=i+1;j<SWEEP_POINTS;j++){if(!is_bad[j]){right=j;break;}}
        if(left>=0&&right>=0){
            float t=(float)(i-left)/(float)(right-left);
            H_phase_out[i]=H_phase_arr[left]+t*(H_phase_arr[right]-H_phase_arr[left]);
        }else if(left>=0)H_phase_out[i]=H_phase_arr[left];
        else if(right>=0)H_phase_out[i]=H_phase_arr[right];
        else H_phase_out[i]=0.0f;
    }
}

void smooth_data(void){
    int W=SMOOTH_WINDOW;
    for(int i=0;i<SWEEP_POINTS;i++){
        float sa=0; int ca=0;
        for(int j=i-W;j<=i+W;j++){
            if(j<0||j>=SWEEP_POINTS)continue;
            sa+=H_amp_arr[j]; ca++;
        }
        H_amp_out[i]=sa/(float)ca;
        float sp=0; int cp=0;
        for(int j=i-W;j<=i+W;j++){
            if(j<0||j>=SWEEP_POINTS)continue;
            sp+=H_phase_out[j]; cp++;
        }
        H_phase_out[i]=(cp>0)?sp/(float)cp:H_phase_out[i];
    }
}

void print_results(void){
    printf("freq(Hz),ch1_amp,ch1_phase,ch2_amp,ch2_phase,H_amp,H_phase\r\n");
    for(int i=0;i<SWEEP_POINTS;i++){
        printf("%.2f,%.4f,%.3f,%.4f,%.3f,%.4f,%.3f\r\n",
            freq_arr[i],ch1_amp_arr[i],ch1_phase_arr[i],
            ch2_amp_arr[i],ch2_phase_arr[i],H_amp_out[i],H_phase_out[i]);
    }
    fflush(stdout);
}

static int sweep_idx=0,sweep_done=0;
int IRQHandler(void*Ref){
    (void)Ref; adc_ready=1;
    if(sweep_done)return 0;
    set_ctrl(CTRL_BIT_DDS); read_bram();
    float freq=SWEEP_START+(float)sweep_idx*SWEEP_STEP;
    int idx=sweep_idx;
    IQ_Raw r1=iq_demodulate_raw(buf_ch1,freq,SAMPLE_FREQ,FFT_LENGTH);
    IQ_Raw r2=iq_demodulate_raw(buf_ch2,freq,SAMPLE_FREQ,FFT_LENGTH);
    freq_arr[idx]=freq;
    ch1_amp_arr[idx]=2.0f*sqrtf(r1.I*r1.I+r1.Q*r1.Q)/(float)FFT_LENGTH;
    ch1_phase_arr[idx]=atan2f(r1.Q,r1.I)*180.0f/PI;
    ch2_amp_arr[idx]=2.0f*sqrtf(r2.I*r2.I+r2.Q*r2.Q)/(float)FFT_LENGTH;
    ch2_phase_arr[idx]=atan2f(r2.Q,r2.I)*180.0f/PI;
    H_amp_arr[idx]=(ch2_amp_arr[idx]>0.001f)?(ch1_amp_arr[idx]/ch2_amp_arr[idx]):0.0f;
    H_phase_arr[idx]=ch2_phase_arr[idx]-ch1_phase_arr[idx];
    if((sweep_idx&0xFF)==0){printf("[%4d/%d]\r\n",sweep_idx,SWEEP_POINTS);fflush(stdout);}
    sweep_idx++;
    if(sweep_idx>=SWEEP_POINTS){
        sweep_done=1; set_ctrl(CTRL_BIT_DDS);
        printf("Post-processing...\r\n"); fflush(stdout);
        remove_phase_outliers(); smooth_data();
        for(int i=0;i<SWEEP_POINTS;i++){if(H_amp_out[i]<0.05f)H_phase_out[i]=0.0f;}
        print_results();
        printf("=== Sweep done ===\r\n"); fflush(stdout);
        return 0;
    }
    float nf=SWEEP_START+(float)sweep_idx*SWEEP_STEP;
    set_dds(nf); delay_us(2000);
    set_ctrl(CTRL_BIT_DDS|CTRL_BIT_ADC_SAMPLE);
    return 0;
}

void setup_irq(void){
    XScuGic_Config*cfg=XScuGic_LookupConfig(INTC_DEVICE);
    XScuGic_CfgInitialize(&Intc,cfg,cfg->CpuBaseAddress);
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler,&Intc);
    Xil_ExceptionEnable();
    XScuGic_Connect(&Intc,PL_IRQ,(Xil_ExceptionHandler)IRQHandler,NULL);
    XScuGic_SetPriorityTriggerType(&Intc,PL_IRQ,0xA0,0x3);
    XScuGic_Enable(&Intc,PL_IRQ);
}

int main(void){
    printf("\r\n=== 2025_G Sweep Test ===\r\n");
    printf("%.0f~%.0fHz, %d pts, step=%.2fHz\r\n",
        SWEEP_START,SWEEP_START+(SWEEP_POINTS-1)*SWEEP_STEP,SWEEP_POINTS,SWEEP_STEP);
    fflush(stdout);
    setup_irq();
    sweep_idx=0; sweep_done=0;
    set_ctrl(0); set_dds(SWEEP_START); delay_us(2000);
    set_ctrl(CTRL_BIT_DDS|CTRL_BIT_ADC_SAMPLE);
    while(!sweep_done);
    while(1);
    return 0;
}
