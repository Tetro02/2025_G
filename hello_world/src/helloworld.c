// ========== 必备头文件 ==========
#include <stdio.h>
#include <string.h>
#include <stdint.h>

// Cortex-A9 适配宏
#define ARM_MATH_CA9
#define __FPU_PRESENT 1U
#include "arm_math.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xscugic.h"
#include "xil_exception.h"

// ========== FFT & ADC 核心参数 ==========
#define FFT_LENGTH 4096
#define SAMPLE_FREQ 299401.1976047f
#define ADC_BIAS 2048.0f
#define ADC_V_RANGE 5.0f
#define ADC_RES (ADC_V_RANGE / 2048.0f)
#define HAMMING_CORRECT 1.85f

// ===================== 适配新Top.v：控制位宏定义 =====================
// 对应Verilog中 ctrl_start_end_flag[3:0]
#define CTRL_BIT_ADC_SAMPLE (1 << 0) // bit0: ADC采样+写BRAM 使能
#define CTRL_BIT_FIR_COEF (1 << 1)   // bit1: FIR系数重载
#define CTRL_BIT_DDS (1 << 2)        // bit2: DDS使能
#define CTRL_BIT_FIR_DAC (1 << 3)    // bit3: FIR+DAC使能

// ===================== 全局大数组 =====================
float32_t fft_in[FFT_LENGTH * 2];
float32_t fft_mag[FFT_LENGTH];
float32_t fft_phase[FFT_LENGTH];
float32_t hamming_window[FFT_LENGTH];
uint16_t dataOut_1[FFT_LENGTH];
uint16_t dataOut_2[FFT_LENGTH];

// ========== BRAM / AXI 地址（与新Top.v完全匹配） ==========
#define BRAM_ADDR XPAR_AXI_BRAM_CTRL_0_BASEADDR
#define LITE_ADDR XPAR_AXI_LITE_PS_TO_PL_PL_0_BASEADDR
#define CTRL_REG_ADDR (LITE_ADDR + 0x00) // 总控制寄存器(对应slv_reg0)
#define LITE1_ADDR (LITE_ADDR + 0x04)
#define LITE2_ADDR (LITE_ADDR + 0x08)
#define LITE3_ADDR (LITE_ADDR + 0x0C)

// ========== 中断配置 ==========
#define INTC_DEVICE_ID XPAR_SCUGIC_SINGLE_DEVICE_ID
#define PL_IRQ_ID 61
XScuGic Intc;

typedef struct
{
    float freq;
    float digital_amp;
    float voltage_amp;
    float phase_deg;
} FFT_Result_TypeDef;

// ==============================================================================
// 【核心函数】统一控制总信号（0-15）
// 参数：flags - 控制字，直接设置 ctrl_start_end_flag[3:0]
// 示例：
//   SetControlFlags(0x01); // 仅bit0=1，ADC采样模式
//   SetControlFlags(0x08); // 仅bit3=1，FIR+DAC模式
//   SetControlFlags(0x05); // bit0+bit2=1，ADC+DDS同时工作
// ==============================================================================
void SetControlFlags(uint32_t flags)
{
    // 只修改低4位，高28位保持为0
    Xil_Out32(CTRL_REG_ADDR, flags & 0x0000000F);
}

// ==============================================================================
// 纯C手写高精度atan2（零依赖，不调用任何库函数，FFT相位专用）
// ==============================================================================
static float fast_atan2f(float y, float x)
{
    const float PI_HALF = 1.5707963267f;
    float abs_y = (y < 0) ? -y : y;
    float angle, r;

    if (x >= 0.0f)
    {
        r = (x - abs_y) / (x + abs_y);
        angle = PI_HALF - PI_HALF * r;
    }
    else
    {
        r = (x + abs_y) / (abs_y - x);
        angle = 3.0f * PI_HALF - PI_HALF * r;
    }
    return (y < 0.0f) ? -angle : angle;
}

// ==============================================================================
// 纯C手写cos函数（彻底抛弃arm_cos_f32，零依赖）
// ==============================================================================
static float fast_cosf(float x)
{
    const float PI_FLOAT = 3.1415926535f;
    x = x - ((int)(x / (2 * PI_FLOAT))) * (2 * PI_FLOAT);
    if (x > PI_FLOAT)
        x = 2 * PI_FLOAT - x;
    float x2 = x * x;
    return 1.0f - x2 / 2.0f + x2 * x2 / 24.0f - x2 * x2 * x2 / 720.0f;
}

// ==============================================================================
// 汉明窗（纯C实现，无CMSIS依赖）
// ==============================================================================
void generate_hamming_window(float32_t *window, uint32_t length)
{
    const float PI_FLOAT = 3.1415926535f;
    for (uint32_t i = 0; i < length; i++)
    {
        window[i] = 0.54f - 0.46f * fast_cosf(2.0f * PI_FLOAT * i / (length - 1));
    }
}

// ==============================================================================
// FFT主函数（零数学库依赖，纯CMSIS FFT + 纯C相位计算）
// ==============================================================================
FFT_Result_TypeDef test_fft_adc(const uint16_t *dataOut)
{
    arm_cfft_instance_f32 fft_inst;
    FFT_Result_TypeDef res;
    const float PI_FLOAT = 3.1415926535f;
    float freq_res = SAMPLE_FREQ / FFT_LENGTH;
    int i;
    float max_mag = 0.0f;
    int max_index = 0;

    memset(fft_in, 0, sizeof(fft_in));

    // ADC数据预处理
    for (i = 0; i < FFT_LENGTH; i++)
    {
        float adc_real = (float)dataOut[i] - ADC_BIAS;
        fft_in[2 * i] = adc_real * hamming_window[i];
        fft_in[2 * i + 1] = 0.0f;
    }

    // CMSIS FFT（仅保留FFT核心，无数学函数）
    arm_cfft_init_f32(&fft_inst, FFT_LENGTH);
    arm_cfft_f32(&fft_inst, fft_in, 0, 1);
    arm_cmplx_mag_f32(fft_in, fft_mag, FFT_LENGTH);

    // 纯C计算相位，零依赖
    for (i = 0; i < FFT_LENGTH; i++)
    {
        float real = fft_in[2 * i];
        float imag = fft_in[2 * i + 1];
        fft_phase[i] = fast_atan2f(imag, real);
    }

    // 找峰值
    for (i = 0; i < FFT_LENGTH / 2; i++)
    {
        if (fft_mag[i] > max_mag)
        {
            max_mag = fft_mag[i];
            max_index = i;
        }
    }

    // 结果计算
    res.freq = max_index * freq_res;
    res.digital_amp = (max_index == 0) ? (max_mag / 4096.0f) : (max_mag / 2048.0f * HAMMING_CORRECT);
    res.voltage_amp = res.digital_amp * ADC_RES * 2.0f;
    res.phase_deg = fft_phase[max_index] * 180.0f / PI_FLOAT;

    return res;
}

// ==============================================================================
// BRAM 读（完全不变）
// ==============================================================================
void psReadBram(void)
{
    for (int i = 0; i < FFT_LENGTH; i++)
    {
        dataOut_1[i] = Xil_In16(BRAM_ADDR + i * 4);
        dataOut_2[i] = Xil_In16(BRAM_ADDR + i * 4 + 2);
    }
}

// ==============================================================================
// 中断服务函数（使用统一控制函数）
// ==============================================================================
void PL_IRQHandler(void *CallbackRef) // PL中断服务函数
{
    (void)CallbackRef;
    SetControlFlags(0x00); // 停止所有功能

    psReadBram();

    FFT_Result_TypeDef ch1 = test_fft_adc(dataOut_1);
    FFT_Result_TypeDef ch2 = test_fft_adc(dataOut_2);

    float amp_ratio = ch2.voltage_amp / ch1.voltage_amp;
    float phase_diff = ch2.phase_deg - ch1.phase_deg;

    printf("=========================================\r\n");
    printf("峰值频率：%.2f Hz\r\n", ch1.freq);
    printf("通道1 幅值：%.4f V | 相位：%.2f °\r\n", ch1.voltage_amp, ch1.phase_deg);
    printf("通道2 幅值：%.4f V | 相位：%.2f °\r\n", ch2.voltage_amp, ch2.phase_deg);
    printf("幅度比值(Ch2/Ch1): %.4f\r\n", amp_ratio);
    printf("相位差(Ch2-Ch1): %.2f °\r\n", phase_diff);
    printf("=========================================\r\n\r\n");

    SetControlFlags(0x01); // 重启ADC采样模式
}

// ==============================================================================
// 中断初始化（完全不变）
// ==============================================================================
int SetupInterruptSystem(void)
{
    XScuGic_Config *IntcConfig;
    int status;

    IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    if (NULL == IntcConfig)
        return XST_FAILURE;

    status = XScuGic_CfgInitialize(&Intc, IntcConfig, IntcConfig->CpuBaseAddress);
    if (status != XST_SUCCESS)
        return XST_FAILURE;

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                                 (Xil_ExceptionHandler)XScuGic_InterruptHandler, &Intc);
    Xil_ExceptionEnable();

    return XST_SUCCESS;
}

int SetupPLInterrupt(void)
{
    int status = XScuGic_Connect(&Intc, PL_IRQ_ID,
                                 (Xil_ExceptionHandler)PL_IRQHandler, NULL);
    if (status != XST_SUCCESS)
        return XST_FAILURE;

    XScuGic_SetPriorityTriggerType(&Intc, PL_IRQ_ID, 0xA0, 0x3);
    XScuGic_Enable(&Intc, PL_IRQ_ID); // <-- 修复拼写错误
    return XST_SUCCESS;
}

// ==============================================================================
// main（使用统一控制函数）
// ==============================================================================
int main(void)
{
    generate_hamming_window(hamming_window, FFT_LENGTH);
    SetupInterruptSystem();
    SetupPLInterrupt();

    // 使用统一控制函数：先停止，再启动ADC采样模式
    SetControlFlags(0x00);
    SetControlFlags(CTRL_BIT_FIR_DAC);

    while (1)
    {
        // 主循环空闲，中断处理采样
    }
    return 0;
}