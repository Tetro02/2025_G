// ========== 2025_G — 学习→校准→模仿 三阶段链路 v4 ==========
// v4: 相位符号修正 + 2048点0~500kHz扫频 + 局部中位数剔除 + 平滑
// 学习: DDS扫频 → IQ解调 → H(f) → 频率采样法算FIR → 系数重载
// 校准: DDS@峰值 → FIR → shift粗调 → mult微调 → ADC反馈
// 模仿: ADC → FIR → shift → mult → DAC (用校准参数)

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <stdlib.h>
#define ARM_MATH_CA9
#define __FPU_PRESENT 1U
#include "arm_math.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xscugic.h"
#include "xil_exception.h"

// ========== 参数 ==========
#define FFT_LENGTH   4096
#define SAMPLE_FREQ  299401.1976047f
#define ADC_BIAS     2048.0f
#define SWEEP_POINTS 2048
#define SWEEP_STEP   244.140625f
#define SWEEP_START  SWEEP_STEP

// 后处理
#define SMOOTH_WINDOW   15
#define LOCAL_WINDOW    10
#define LOCAL_THRESHOLD 15.0f

// 控制位
#define CTRL_BIT_ADC_SAMPLE (1 << 0)  // ADC采集→写BRAM（toggle bit0复位后启动新一轮4096点采集）
#define CTRL_BIT_FIR_COEF   (1 << 1)  // FIR系数重载（BRAM→FIR IP AXI-Stream通道）
#define CTRL_BIT_DDS        (1 << 2)  // DDS直通DAC输出（扫频激励源，正弦波输出）
#define CTRL_BIT_FIR_DAC    (1 << 3)  // 模仿模式（ADC→FIR→shift→mult→DAC链路）
#define CTRL_BIT_CAL        (1 << 4)  // 校准模式（DDS→FIR→shift→mult→DAC + ADC反馈采集）

// 地址
#define BRAM_ADDR  XPAR_AXI_BRAM_CTRL_0_BASEADDR
#define LITE_ADDR  XPAR_AXI_LITE_PS_TO_PL_PL_0_BASEADDR
#define CTRL_REG   (LITE_ADDR + 0x00)
#define DDS_FREQ   (LITE_ADDR + 0x04)
#define DDS_CTRL   (LITE_ADDR + 0x08)
#define CAL_REG    (LITE_ADDR + 0x0C)

// DDS
#define DDS_CLK      50000000.0f
#define DDS_PHASE_B  28
#define DDS_WAVE_SIN 0

// FIR
#define FIR_TAPS          1001
#define N_COEFFS_RELOAD   506
#define BRAM_COEFF_START  16400
#define SKIP_SWEEP        1       // 1=跳过扫频, 用硬编码系数直接校准

// 中断
#define INTC_DEVICE  XPAR_SCUGIC_SINGLE_DEVICE_ID
#define PL_IRQ       61

// ========== 全局变量 ==========
XScuGic Intc;
static volatile int adc_ready = 0;

// 数据缓冲
static uint16_t buf_ch1[FFT_LENGTH];
static uint16_t buf_ch2[FFT_LENGTH];

// 扫频结果
static float freq_arr     [SWEEP_POINTS];
static float ch1_amp_arr  [SWEEP_POINTS];
static float ch1_phase_arr[SWEEP_POINTS];
static float ch2_amp_arr  [SWEEP_POINTS];
static float ch2_phase_arr[SWEEP_POINTS];
static float H_amp_arr    [SWEEP_POINTS];
static float H_phase_arr  [SWEEP_POINTS];
static float H_amp_out    [SWEEP_POINTS];
static float H_phase_out  [SWEEP_POINTS];

// 学习结果
static float  peak_freq = 0, peak_amp = 0;
static int16_t fir_coeffs[FIR_TAPS];

#if SKIP_SWEEP
#include "saved_fir.h"
#endif

// 校准结果
static int      cal_opt_shift = 0;
static uint16_t cal_opt_coef  = 0x8000;

// ========== 数学 ==========
// PI 由 CMSIS arm_math.h 定义

static float fast_cosf(float x)
{
    x = x - ((int)(x / (2.0f * PI))) * (2.0f * PI);
    if (x > PI) x = 2.0f * PI - x;
    float x2 = x * x;
    return 1.0f - x2 / 2.0f + x2 * x2 / 24.0f - x2 * x2 * x2 / 720.0f;
}
static float fast_sinf(float x) { return fast_cosf(x - PI / 2.0f); }

// ========== 局部中位数 ==========
static float local_median(float *arr, int center, int W)
{
    float vals[41]; int n = 0;
    for (int j = center - W; j <= center + W; j++) {
        if (j >= 0 && j < SWEEP_POINTS) vals[n++] = arr[j];
    }
    for (int a = 0; a < n - 1; a++)
        for (int b = a + 1; b < n; b++)
            if (vals[a] > vals[b]) { float t = vals[a]; vals[a] = vals[b]; vals[b] = t; }
    return vals[n / 2];
}

// ========== IQ 解调 ==========
typedef struct { float I, Q; } IQ_Raw;

IQ_Raw iq_demodulate_raw(const uint16_t *samples, float freq_hz, float fs, uint32_t N)
{
    float I = 0, Q = 0, omega = 2.0f * PI * freq_hz / fs, phase_acc = 0;
    for (uint32_t n = 0; n < N; n++) {
        float s = (float)samples[n] - ADC_BIAS;
        I += s * fast_cosf(phase_acc);
        Q += s * fast_sinf(phase_acc);
        phase_acc += omega;
        if (phase_acc >= 2.0f * PI) phase_acc -= 2.0f * PI;
    }
    IQ_Raw r; r.I = I; r.Q = Q; return r;
}

// ========== 控制 ==========
void set_ctrl(uint32_t flags)   { Xil_Out32(CTRL_REG, flags & 0x1F); }
void set_dds(float freq_hz)
{
    uint32_t fw = (uint32_t)(freq_hz * (float)(1u << DDS_PHASE_B) / DDS_CLK + 0.5f);
    if (fw > 0x0FFFFFFF) fw = 0x0FFFFFFF;
    Xil_Out32(DDS_FREQ, fw);
    Xil_Out32(DDS_CTRL, (255 << 13) | (DDS_WAVE_SIN << 11) | 0);
}
void set_cal(uint8_t shift, uint16_t coef) {
    Xil_Out32(CAL_REG, ((uint32_t)coef << 5) | (shift & 0x1F));
}
void read_bram(void) {
    for (int i = 0; i < FFT_LENGTH; i++) {
        buf_ch1[i] = Xil_In16(BRAM_ADDR + i * 4);
        buf_ch2[i] = Xil_In16(BRAM_ADDR + i * 4 + 2);
    }
}
void delay_us(uint32_t us) {
    for (volatile uint32_t i = 0; i < us * 166; i++);
}
void wait_adc(void) { adc_ready = 0; while (!adc_ready); }

// ========== 后处理 ==========
void remove_phase_outliers(void)
{
    static int is_bad[SWEEP_POINTS]; int W = LOCAL_WINDOW;
    for (int i = 0; i < SWEEP_POINTS; i++) {
        float med = local_median(H_phase_arr, i, W);
        is_bad[i] = (fabsf(H_phase_arr[i] - med) > LOCAL_THRESHOLD) ? 1 : 0;
    }
    for (int i = 0; i < SWEEP_POINTS; i++) {
        if (!is_bad[i]) { H_phase_out[i] = H_phase_arr[i]; continue; }
        int left = -1, right = -1;
        for (int j = i-1; j >= 0; j--) { if (!is_bad[j]) { left = j; break; } }
        for (int j = i+1; j < SWEEP_POINTS; j++) { if (!is_bad[j]) { right = j; break; } }
        if (left >= 0 && right >= 0) {
            float t = (float)(i - left) / (float)(right - left);
            H_phase_out[i] = H_phase_arr[left] + t * (H_phase_arr[right] - H_phase_arr[left]);
        } else if (left >= 0) H_phase_out[i] = H_phase_arr[left];
        else if (right >= 0) H_phase_out[i] = H_phase_arr[right];
        else H_phase_out[i] = 0.0f;
    }
}

void smooth_data(void)
{
    int W = SMOOTH_WINDOW;
    for (int i = 0; i < SWEEP_POINTS; i++) {
        float sa = 0; int ca = 0;
        for (int j = i-W; j <= i+W; j++) {
            if (j < 0 || j >= SWEEP_POINTS) continue;
            sa += H_amp_arr[j]; ca++;
        }
        H_amp_out[i] = sa / (float)ca;
        float sp = 0; int cp = 0;
        for (int j = i-W; j <= i+W; j++) {
            if (j < 0 || j >= SWEEP_POINTS) continue;
            sp += H_phase_out[j]; cp++;
        }
        H_phase_out[i] = (cp > 0) ? sp / (float)cp : H_phase_out[i];
    }
}

// ========== FIR 系数计算 (频率采样法, 相位符号修正) ==========
void compute_fir(int n_points, int n_taps, int16_t *coeffs)
{
    int N_FFT = 2 * n_points;
    static float32_t fb[4096 * 2];  // N_FFT=4096 → 32KB, 静态分配避免 malloc 失败
    memset(fb, 0, sizeof(fb));

    // 纯幅值设计: 相位归零, IFFT输出对称, 匹配FPGA对称FIR
    fb[0] = H_amp_out[0];
    fb[1] = 0.0f;
    for (int k = 0; k < n_points; k++) {
        fb[2 * (k + 1)]     = H_amp_out[k];
        fb[2 * (k + 1) + 1] = 0.0f;
    }
    // 负频率共轭对称
    for (int k = 1; k <= n_points; k++) {
        fb[2 * (N_FFT - k)]     =  fb[2 * k];
        fb[2 * (N_FFT - k) + 1] = -fb[2 * k + 1];
    }

    printf("FIR: N_FFT=%d, IFFT...\r\n", N_FFT); fflush(stdout);

    arm_cfft_instance_f32 fft_inst;
    arm_cfft_init_f32(&fft_inst, N_FFT);
    arm_cfft_f32(&fft_inst, fb, 1, 1); // IFFT, bitReverse=1

    // fftshift 等效: 取主瓣 (h[0]在n=0, 从尾部绕回)
    int start = N_FFT - n_taps / 2;
    float maxv = 0;
    float h_tmp[FIR_TAPS];
    for (int i = 0; i < n_taps; i++) {
        int si = start + i;
        if (si >= N_FFT) si -= N_FFT;
        if (si < 0)      si += N_FFT;
        float v = fb[2 * si];
        float w = 0.54f - 0.46f * fast_cosf(2.0f * PI * (float)i / (float)(n_taps - 1));
        v *= w;
        h_tmp[i] = v;
        if (fabsf(v) > maxv) maxv = fabsf(v);
    }
    // DEBUG: h_tmp前后各4个

    for (int i = 0; i < n_taps; i++) {
        float v = h_tmp[i] / maxv * 32767.0f;
        int iv = (int)(v + (v > 0 ? 0.5f : -0.5f));
        if (iv > 32767) iv = 32767; else if (iv < -32767) iv = -32767;
        coeffs[i] = (int16_t)iv;
    }
    printf("FIR: %d tap, min=%d max=%d\r\n", n_taps,
           (int)coeffs[0], (int)coeffs[n_taps - 1]);
}

// ========== 系数重载 ==========
void reload_fir(int16_t *coeffs)
{
    printf("写入 BRAM (addr=%d, %d coeffs)...\r\n", BRAM_COEFF_START, N_COEFFS_RELOAD);
    for (int i = 0; i < N_COEFFS_RELOAD; i++) {
        Xil_Out32(BRAM_ADDR + BRAM_COEFF_START + i * 4, ((uint32_t)(uint16_t)coeffs[i]) << 16);
    }
    set_ctrl(CTRL_BIT_FIR_COEF);
    delay_us(10000);
    set_ctrl(0x00);
    printf("系数重载完成\r\n");
}

// ========== 校准 ==========
int calibrate_shift(float freq)
{
    printf("--- 粗调 shift (全扫31→0) ---\r\n");
    set_ctrl(CTRL_BIT_CAL | CTRL_BIT_ADC_SAMPLE);
    set_dds(freq);
    float best_amp = 0; int best_s = 0;
    for (int s = 31; s >= 0; s--) {
        set_cal((uint8_t)s, 0x8000);
        set_ctrl(CTRL_BIT_CAL);  delay_us(100);              // 只关 ADC，DDS+FIR 不停
        set_ctrl(CTRL_BIT_CAL | CTRL_BIT_ADC_SAMPLE);        // 重新启动 ADC 采集
        wait_adc();
        read_bram();
        IQ_Raw r = iq_demodulate_raw(buf_ch2, freq, SAMPLE_FREQ, FFT_LENGTH);
        float amp = 2.0f * sqrtf(r.I*r.I + r.Q*r.Q) / (float)FFT_LENGTH;
        printf("shift=%2d amp=%.1f\r\n", s, amp);
        delay_us(1000000);
        if (amp > best_amp) { best_amp = amp; best_s = s; }
    }
    printf("最优 shift=%d (amp=%.1f)\r\n", best_s, best_amp);
    return best_s;
}

uint16_t calibrate_coef(int shift, float freq, float target)
{
    printf("--- 微调 coef ---\r\n");
    for (uint16_t c = 0xFFFF; c > 0x0400; c -= 0x0400) {
        set_cal((uint8_t)shift, c);
        set_ctrl(CTRL_BIT_CAL);  delay_us(100);              // 只关 ADC，DDS+FIR 不停
        set_ctrl(CTRL_BIT_CAL | CTRL_BIT_ADC_SAMPLE);        // 重新启动 ADC 采集
        wait_adc();
        read_bram();
        IQ_Raw r = iq_demodulate_raw(buf_ch2, freq, SAMPLE_FREQ, FFT_LENGTH);
        float amp = 2.0f * sqrtf(r.I*r.I + r.Q*r.Q) / (float)FFT_LENGTH;
        printf("coef=0x%04X amp=%.4f (target=%.4f)\r\n", c, amp, target);
        if (fabsf(amp - target) / target < 0.02f) {
            printf("最优 coef=0x%04X\r\n", c);
            return c;
        }
    }
    printf("未完全匹配, 用默认 0x8000\r\n");
    return 0x8000;
}

void calibrate(void)
{
    printf("\r\n========== 校准模式 ==========\r\n");
    peak_freq = freq_arr[0]; peak_amp = H_amp_out[0];
    float target_adc = ch2_amp_arr[0];  // 校准走 ADC2(参考)，目标 = 扫频时参考幅值
    int pi = 0;
    for (int i = 1; i < SWEEP_POINTS; i++) {
        if (H_amp_out[i] > peak_amp) {
            peak_amp = H_amp_out[i]; peak_freq = freq_arr[i];
            target_adc = ch2_amp_arr[i]; pi = i;
        }
    }
    printf("峰值: f=%.1f Hz, |H|=%.4f ch2_amp=%.1f (idx=%d)\r\n", peak_freq, peak_amp, target_adc, pi);
    cal_opt_shift = calibrate_shift(peak_freq);
    cal_opt_coef  = calibrate_coef(cal_opt_shift, peak_freq, target_adc);
    set_ctrl(0x00);
    printf("校准完成: shift=%d, coef=0x%04X\r\n", cal_opt_shift, cal_opt_coef);
}

// ========== 输出扫频结果 ==========
void print_results(void)
{
    printf("freq(Hz),ch1_amp,ch1_phase,ch2_amp,ch2_phase,H_amp,H_phase\r\n");
    for (int i = 0; i < SWEEP_POINTS; i++) {
        printf("%.2f,%.4f,%.3f,%.4f,%.3f,%.4f,%.3f\r\n",
               freq_arr[i], ch1_amp_arr[i], ch1_phase_arr[i],
               ch2_amp_arr[i], ch2_phase_arr[i], H_amp_out[i], H_phase_out[i]);
    }
    fflush(stdout);
}

// ========== 中断服务 ==========
static int sweep_idx = 0, sweep_done = 0, calib_mode = 0;

int IRQHandler(void *Ref)
{
    (void)Ref;
    adc_ready = 1;
    if (calib_mode || sweep_done) return 0;

    set_ctrl(CTRL_BIT_DDS);
    read_bram();

    float freq = SWEEP_START + (float)sweep_idx * SWEEP_STEP;
    IQ_Raw r1 = iq_demodulate_raw(buf_ch1, freq, SAMPLE_FREQ, FFT_LENGTH);
    IQ_Raw r2 = iq_demodulate_raw(buf_ch2, freq, SAMPLE_FREQ, FFT_LENGTH);

    freq_arr[sweep_idx] = freq;
    ch1_amp_arr[sweep_idx]   = 2.0f * sqrtf(r1.I*r1.I + r1.Q*r1.Q) / (float)FFT_LENGTH;
    ch1_phase_arr[sweep_idx] = atan2f(r1.Q, r1.I) * 180.0f / PI;
    ch2_amp_arr[sweep_idx]   = 2.0f * sqrtf(r2.I*r2.I + r2.Q*r2.Q) / (float)FFT_LENGTH;
    ch2_phase_arr[sweep_idx] = atan2f(r2.Q, r2.I) * 180.0f / PI;
    H_amp_arr[sweep_idx]     = (ch2_amp_arr[sweep_idx] > 0.001f) ? (ch1_amp_arr[sweep_idx] / ch2_amp_arr[sweep_idx]) : 0.0f;
    H_phase_arr[sweep_idx]   = ch2_phase_arr[sweep_idx] - ch1_phase_arr[sweep_idx];

    if ((sweep_idx & 0xFF) == 0) { printf("[%4d/%d]\r\n", sweep_idx, SWEEP_POINTS); fflush(stdout); }

    sweep_idx++;
    if (sweep_idx >= SWEEP_POINTS) {
        sweep_done = 1;
        set_ctrl(CTRL_BIT_DDS);
        printf("扫频完成，后处理...\r\n"); fflush(stdout);

        remove_phase_outliers();
        smooth_data();
        print_results();
        printf("=== 扫频结果输出完成 ===\r\n"); fflush(stdout);
        return 0;
    }

    float nf = SWEEP_START + (float)sweep_idx * SWEEP_STEP;
    set_dds(nf);
    delay_us(2000);
    set_ctrl(CTRL_BIT_DDS | CTRL_BIT_ADC_SAMPLE);
    return 0;
}

// ========== 中断初始化 ==========
void setup_irq(void)
{
    XScuGic_Config *cfg = XScuGic_LookupConfig(INTC_DEVICE);
    XScuGic_CfgInitialize(&Intc, cfg, cfg->CpuBaseAddress);
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
        (Xil_ExceptionHandler)XScuGic_InterruptHandler, &Intc);
    Xil_ExceptionEnable();
    XScuGic_Connect(&Intc, PL_IRQ, (Xil_ExceptionHandler)IRQHandler, NULL);
    XScuGic_SetPriorityTriggerType(&Intc, PL_IRQ, 0xA0, 0x3);
    XScuGic_Enable(&Intc, PL_IRQ);
}

// ========== 主函数 ==========
int main(void)
{
    printf("\r\n=== 2025_G v4 ===\r\n");
    setup_irq();

#if SKIP_SWEEP
    printf("--- 跳过扫频, 使用硬编码系数 ---\r\n");
    memcpy(fir_coeffs, saved_fir, sizeof(saved_fir));
    printf("系数已载入 (%d tap)\r\n", FIR_TAPS);
#else
    // ---- 阶段1: 学习 ----
    printf("--- 阶段1: 扫频 ---\r\n");
    printf("%.0f~%.0fHz, %d点, 步进%.2fHz\r\n",
           SWEEP_START, SWEEP_START + (SWEEP_POINTS-1)*SWEEP_STEP, SWEEP_POINTS, SWEEP_STEP);
    fflush(stdout);

    sweep_idx  = 0;
    sweep_done = 0;
    calib_mode = 0;
    set_ctrl(0x00);
    set_dds(SWEEP_START);
    delay_us(2000);
    set_ctrl(CTRL_BIT_DDS | CTRL_BIT_ADC_SAMPLE);
    while (!sweep_done);

    // ---- 阶段2: FIR 系数计算 + 重载 ----
    printf("\r\n--- 阶段2: FIR 系数 ---\r\n"); fflush(stdout);
    compute_fir(SWEEP_POINTS, FIR_TAPS, fir_coeffs);

    // ---- 输出重载系数 (前506个, 对称FIR独立系数) ----
    printf("\r\n=== 重载系数 (%d个) ===\r\n", N_COEFFS_RELOAD);
    printf("static const int16_t reload_coeffs[%d] = {\r\n", N_COEFFS_RELOAD);
    for (int i = 0; i < N_COEFFS_RELOAD; i++) {
        printf("%6d", fir_coeffs[i]);
        if (i < N_COEFFS_RELOAD - 1) printf(",");
        if ((i & 7) == 7) printf("\r\n");
    }
    printf("\r\n};\r\n");
    printf("=== 重载系数输出完成 ===\r\n"); fflush(stdout);
#endif
    reload_fir(fir_coeffs);

    // ---- 7 秒窗口：断开外接滤波器，让校准走直连链路 ----
    printf("\r\n=== 请断开外接滤波器，7秒后开始校准... ===\r\n");
    for (int t = 7; t > 0; t--) {
        printf("%d...\r\n", t); fflush(stdout);
        delay_us(1000000);
    }

    // ---- 阶段3: 校准 ----
    calib_mode = 1;
    calibrate();

    // ---- 阶段4: 模仿 ----
    printf("\r\n========== 模仿模式 ==========\r\n");
    set_cal((uint8_t)cal_opt_shift, cal_opt_coef);
    set_ctrl(CTRL_BIT_FIR_DAC);
    printf("运行中... ADC→FIR→shift→mult→DAC\r\n");
    printf("shift=%d coef=0x%04X\r\n", cal_opt_shift, cal_opt_coef);
    fflush(stdout);

    while (1);
    return 0;
}
