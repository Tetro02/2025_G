// ========== 必备头文件 ==========
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "arm_math.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xscugic.h"
#include "xil_exception.h"

// ========== FFT & ADC 核心参数 ==========
#define FFT_LENGTH 4096
#define SAMPLE_FREQ 299401.1976047f // 你的采样率
#define SIGNAL_FREQ 50000.0f
#define ADC_BIAS 2048.0f                // ADC 0V偏置
#define ADC_V_RANGE 5.0f                // 单极性电压范围 ±5V
#define ADC_RES (ADC_V_RANGE / 2048.0f) // 电压分辨率
#define HAMMING_CORRECT 1.85f           // 汉明窗幅值校正系数

// ===================== 全局大数组（全部放在这里）=====================
float32_t fft_in[FFT_LENGTH * 2];     // FFT输入数组（全局）
float32_t fft_mag[FFT_LENGTH];        // FFT模值数组（全局）
float32_t hamming_window[FFT_LENGTH]; // 汉明窗数组（全局，仅生成1次）
uint16_t dataOut_1[FFT_LENGTH];       // BRAM读取缓存（全局）
uint16_t dataOut_2[FFT_LENGTH];       // BRAM读取缓存（全局）

// ========== BRAM / AXI 地址定义 ==========
#define BRAM_ADDR XPAR_AXI_BRAM_CTRL_0_BASEADDR
#define LITE_ADDR XPAR_AXI_LITE_PS_TO_PL_PL_0_BASEADDR
#define ADC_START_ADDR (LITE_ADDR + 0x00)
#define LITE1_ADDR (LITE_ADDR + 0x04)
#define LITE2_ADDR (LITE_ADDR + 0x08)
#define LITE3_ADDR (LITE_ADDR + 0x0C)

// ========== 中断配置 ==========
#define INTC_DEVICE_ID XPAR_SCUGIC_SINGLE_DEVICE_ID
#define PL_IRQ_ID 61
XScuGic Intc; // 中断控制器（全局）

// ==============================================================================
// 手动生成汉明窗（仅初始化调用1次）
// ==============================================================================
void generate_hamming_window(float32_t *window, uint32_t length)
{
    for (uint32_t i = 0; i < length; i++)
    {
        window[i] = 0.54f - 0.46f * arm_cos_f32(2.0f * PI * i / (length - 1));
    }
}

// ==============================================================================
// FFT处理函数：峰值检测 + 幅值计算
// ==============================================================================
void test_fft_adc(const uint16_t *dataOut)
{
    arm_cfft_instance_f32 fft_inst;
    float freq_res = SAMPLE_FREQ / FFT_LENGTH; // 频率分辨率
    int i;
    // 峰值检测变量
    float max_mag = 0.0f;
    int max_index = 0;
    float peak_freq, peak_digital_amp, peak_voltage_amp;

    // 清空FFT输入数组
    memset(fft_in, 0, sizeof(fft_in));

    // ========== 数据预处理：模拟ADC + 去偏置 + 汉明窗 ==========
    for (i = 0; i < FFT_LENGTH; i++)
    {
        uint16_t adc_raw = dataOut[i];
        float adc_real = (float)adc_raw - ADC_BIAS;
        fft_in[2 * i] = adc_real * hamming_window[i];
        fft_in[2 * i + 1] = 0.0f;
    }

    // ========== FFT 计算 ==========
    arm_cfft_init_f32(&fft_inst, FFT_LENGTH);
    arm_cfft_f32(&fft_inst, fft_in, 0, 1);
    arm_cmplx_mag_f32(fft_in, fft_mag, FFT_LENGTH);

    // ========== 幅值计算 + 搜索最大峰值 ==========
    // printf("\n========== ADC(±5V,2048=0V) FFT + 汉明窗 ==========\n");
    for (i = 0; i < FFT_LENGTH / 2; i++)
    {
        float digital_amp;
        // 归一化处理
        if (i == 0)
        {
            digital_amp = fft_mag[i] / 4096.0f;
        }
        else
        {
            digital_amp = fft_mag[i] / 2048.0f;
            digital_amp *= HAMMING_CORRECT;
        }

        // 搜索FFT最大模值峰值（原始模值）
        if (fft_mag[i] > max_mag)
        {
            max_mag = fft_mag[i];
            max_index = i;
        }

        // 保留你原有的打印逻辑
        // printf("%.4f\n", fft_mag[i]);
    }

    // ========== 计算峰值的频率、数字幅值、电压幅值 ==========
    peak_freq = max_index * freq_res;
    // 计算峰值对应的校正后幅值
    if (max_index == 0)
    {
        peak_digital_amp = max_mag / 4096.0f;
    }
    else
    {
        peak_digital_amp = max_mag / 2048.0f;
        peak_digital_amp *= HAMMING_CORRECT;
    }
    peak_voltage_amp = peak_digital_amp * ADC_RES;

    // ========== 打印峰值结果（核心新增功能） ==========
    printf("峰值频率: %.2f Hz; 峰值数字幅值: %.2f; 峰值真实电压: %.4f V\n", peak_freq, peak_digital_amp, peak_voltage_amp);
}

// ==============================================================================
// 原有 BRAM 操作函数
// ==============================================================================
void psWriteBram(void)
{
    printf("This is psWriteBram function\r\n");
    int dataIn[8] = {11, 12, 13, 14, 15, 16, 17, 18};
    for (int i = 0; i < 8; i++)
    {
        Xil_Out32(BRAM_ADDR + 4 * i, dataIn[i]);
    }
}

void psReadBram(void)
{
    // printf("This is psReadBram function\r\n");
    for (int i = 0; i < FFT_LENGTH; i++)
    {
        dataOut_1[i] = Xil_In16(BRAM_ADDR + i * 4);
        dataOut_2[i] = Xil_In16(BRAM_ADDR + i * 4 + 2);
    }
    // printf("\r\n");
}

// ==============================================================================
// 中断服务函数
// ==============================================================================
void PL_IRQHandler(void *CallbackRef)
{
    (void)CallbackRef;
    Xil_Out32(ADC_START_ADDR, 0);
    psReadBram();            // 从BRAM读取数据到全局数组
    test_fft_adc(dataOut_1); // 执行FFT测试（自动检测峰值）
    test_fft_adc(dataOut_2);
    Xil_Out32(ADC_START_ADDR, 1);
}

// ==============================================================================
// 中断系统初始化
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
                                 (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                                 &Intc);
    Xil_ExceptionEnable();

    return XST_SUCCESS;
}

// ==============================================================================
// PL 中断配置
// ==============================================================================
int SetupPLInterrupt(void)
{
    int status;
    status = XScuGic_Connect(&Intc, PL_IRQ_ID,
                             (Xil_ExceptionHandler)PL_IRQHandler,
                             NULL);
    if (status != XST_SUCCESS)
        return XST_FAILURE;

    XScuGic_SetPriorityTriggerType(&Intc, PL_IRQ_ID, 0xA0, 0x3);
    XScuGic_Enable(&Intc, PL_IRQ_ID);

    return XST_SUCCESS;
}

// ==============================================================================
// 主函数
// ==============================================================================
int main(void)
{
    // printf("PL IRQ + ADC FFT + Hamming Window Test Start\r\n");

    // 汉明窗只生成1次
    generate_hamming_window(hamming_window, FFT_LENGTH);

    // 初始化中断系统
    SetupInterruptSystem();
    SetupPLInterrupt();

    Xil_Out32(ADC_START_ADDR, 0);
    Xil_Out32(ADC_START_ADDR, 1);

    // 主循环
    while (1)
    {
        // 重复调用也只会复用窗函数
        // test_fft_adc();
    }

    return 0;
}