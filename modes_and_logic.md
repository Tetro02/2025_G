# 2025_G FPGA 项目 — 模式与执行逻辑梳理

> 基于 `top.v` 及各子模块源码分析，2026-06-02 (更新)

---

## 一、系统架构概览

| 项目 | 说明 |
|------|------|
| **器件** | XC7Z020CLG484-1 (Zynq-7020) |
| **顶层模块** | `Test_Top` ([top.v](2025_G.srcs/sources_1/new/top.v)) |
| **PL 时钟** | 全 PL 统一 50MHz，由 PS IO PLL 产生 `FCLK_CLK0` |
| **PS-PL 接口** | M_AXI_GP0 → SmartConnect → (1) AXI BRAM Ctrl → BRAM Port A、(2) 自定义 AXI-Lite IP → 控制寄存器 |
| **中断** | IRQ_F2P：ADC 采样完成时 `adc_end_flag` 拉高通知 PS |
| **测量方式** | IQ 正交解调（替代 CMSIS FFT）— ISR 耗时 ~0.2ms |
| **工作流程** | **学习 → 校准 → 模仿** 三阶段自动链路 |

---

## 二、控制寄存器映射

自定义 AXI-Lite IP 基址 **`0x43C0_0000`**，4 个 32 位寄存器：

| 寄存器 | 偏移 | 顶层信号名 | 用途 |
|--------|------|-----------|------|
| `slv_reg0` | 0x00 | `ctrl_start_end_flag[31:0]` | **模式控制** |
| `slv_reg1` | 0x04 | `dds_ctrl_reg0[31:0]` | DDS 频率字 |
| `slv_reg2` | 0x08 | `dds_ctrl_reg1[31:0]` | DDS 参数（相位/波形/幅度） |
| `slv_reg3` | 0x0C | `slv_reg3[31:0]` | **校准参数** |

### slv_reg0 位域

```
[31:5]  — 保留
[4]     — CAL_MODE         (校准模式: DDS→FIR→shift→mult→DAC)
[3]     — FIR_DAC_MODE     (模仿模式: ADC→FIR→shift→mult→DAC)
[2]     — DDS_MODE         (DDS 波形生成)
[1]     — FIR_COEF_RELOAD  (FIR 系数重载，最高优先级)
[0]     — ADC_BRAM_MODE    (ADC 采样存 BRAM)
```

### slv_reg1 位域

```
[31:28] — 保留
[27:0]  — DDS 频率控制字（28 位相位累加步进）
```

### slv_reg2 位域

```
[31:21] — 保留
[20:13] — amplitude  (DDS 幅度缩放，0–255，128=原始幅度)
[12:11] — wave_sel   (DDS 波形选择，0–3，共 4 种波形)
[10:0]  — phase_off  (DDS 相位偏移，11 位)
```

### slv_reg3 位域（校准参数）

```
[31:21] — 保留
[20:5]  — cal_coef    (乘法器系数，Q1.15 无符号: 0x8000=1.0, 0xFFFF≈2.0)
[4:0]   — cal_shift   (算术右移位数，0~31)
```

---

## 三、模式优先级编码

```verilog
// bit[1] 最高优先级 — 无条件屏蔽所有
fir_coef_reload_mode = ctrl[1];

// bit[4] 与 bit[3] 互斥，共用 FIR→shift→mult→DAC 链路
cal_mode   = !ctrl[1] && !ctrl[3] && ctrl[4];
fir_dac_mode = !ctrl[1] && !ctrl[0] && !ctrl[2] && !ctrl[4] && ctrl[3];
use_fir_chain = cal_mode || fir_dac_mode;  // 共享的信号链路

dds_mode   = !ctrl[1] && !ctrl[3] && !ctrl[4] && ctrl[2];
adc_bram_mode = !ctrl[1] && !ctrl[3] && (ctrl[0] || ctrl[4]);  // 校准时间时使能 ADC
```

**优先级**: bit1 > {bit4 或 bit3} > bit2 > bit0

---

## 四、五种工作模式

### 模式 1 — ADC BRAM 采样

| 属性 | 值 |
|------|-----|
| 控制位 | `bit[0]=1`，且 `bit[1]=bit[3]=0` |
| 模块 | `adc_bram_sample` ([bram_ctrl_my.v](2025_G.srcs/sources_1/new/bram_ctrl_my.v)) |
| 采样率 | 50MHz / 167 ≈ **299.4 kHz** |
| 样本数 | 4096 个 |
| BRAM 写入范围 | 地址 0x0000 ~ 0x3FFC（字节寻址，每地址+4） |

**数据流**:
```
ADC1 (12bit) ──┐
               ├──> 抽取167 ──> 打包 32bit {4'd0, ADC1, 4'd0, ADC2} ──> BRAM Port B
ADC2 (12bit) ──┘
```

**执行**:
1. PS 写 `bit[0]=1` → 模块退出复位
2. 每 167 周期采集一次，双路打包写入 BRAM
3. 4096 次写后 `adc_end_flag` 拉高 → **IRQ_F2P 中断**通知 PS
4. PS 读 BRAM → IQ 正交解调提取幅相

**DAC 输出**: `0`

---

### 模式 2 — FIR 系数重载（最高优先级）

| 属性 | 值 |
|------|-----|
| 控制位 | `bit[1]=1`（其他位无视） |
| 模块 | `bram_read_fir_reload` ([bram_fir_reload.v](2025_G.srcs/sources_1/new/bram_fir_reload.v)) |
| BRAM 起始地址 | **16400**（十进制字节地址） |
| 系数数量 | **506 个**（1001 tap 对称 FIR, reload_order 决定） |
| 系数宽度 | 16 位（取 BRAM 32 位的高 16 位） |

**数据流**:
```
BRAM[16400 + n*4][31:16] → s_axis_reload_tdata → FIR Compiler IP reload 端口
                                                         │
                                  506 个全部发送后 s_axis_config=1 → 触发系数更新
```

**执行**:
1. PS 通过 AXI 将 506 个系数写入 BRAM 地址 16400+
2. PS 写 `bit[1]=1` → PL 模块读 BRAM → AXI-Stream 重载
3. 506 个系数发送完 → `s_axis_config_tdata=1` 激活
4. PS 清除 `bit[1]`

---

### 模式 3 — DDS 波形生成

| 属性 | 值 |
|------|-----|
| 控制位 | `bit[2]=1`，且 `bit[1]=bit[3]=bit[4]=0` |
| 模块 | `dds_10hz_2mhz` ([DDS.v](2025_G.srcs/sources_1/new/DDS.v)) |
| 相位累加器 | 28 位 |
| ROM 深度 | 8192 = 4 波形 × 2048 点 |
| DAC 输出 | 14 位无符号 |

**数据流**:
```
freq_word(28bit) → [+]→ phase_acc(28bit) → phase_acc[27:17] + phase_off
                                                      ↓
                                         {wave_sel, addr} → ROM(8192×14bit)
                                                      ↓
                                         (raw-8192) × amp/256 + 8192 → DAC
```

- 频率分辨率: 50MHz / 2^28 ≈ **0.186 Hz**
- 输出频率: `freq_word × 0.186 Hz`

---

### 模式 4 — 校准模式 (NEW)

| 属性 | 值 |
|------|-----|
| 控制位 | `bit[4]=1`，且 `bit[1]=bit[3]=0`（常与 bit[0] 组合: `0x11`） |
| FIR 输入 | **DDS 内部旁路**（14b→12b signed） |
| 输出链路 | FIR → `>>> cal_shift` → `× cal_coef (Q1.15)` → `+8192` → DAC |
| 反馈 | ADC B 路读幅值 → PS 调节 cal_shift / cal_coef |

**数据流**:
```
DDS(14b) → dds_to_fir(12b signed) → FIR(40b全精度)
    → >>> cal_shift (粗调)
    → × cal_coef (微调, Q1.15)
    → >>> 15 + 8192 → clamp [1,16382] → DAC 14bit
    → 外部回环 → ADC_B → PS IQ解调幅值
```

**校准算法**（PS 端）:
1. **粗调**: mult=1.0(0x8000), shift 从 31→0 递减扫描
   - 每次测 IQ 幅值，与上一轮比较
   - 若 `A[s] < A[s+1] × 1.8` → 削顶 → 最优 shift = s+1
2. **微调**: 固定最优 shift, coef 从 0xFFFF→0x0400 递减扫描
   - 匹配学习模式存储的峰值幅值 → 最优 coef

---

### 模式 5 — 模仿模式（原 FIR 实时滤波，升级）

| 属性 | 值 |
|------|-----|
| 控制位 | `bit[3]=1`，且 `bit[1]=bit[0]=bit[2]=bit[4]=0` |
| 模块 | `fir_adc12_dac8` ([fir.v](2025_G.srcs/sources_1/new/fir.v)) + shift + multiplier |
| FIR 输入 | **外部 ADC** (12-bit) |
| 输出链路 | FIR → `>>> cal_shift` → `× cal_coef (Q1.15)` → `+8192` → DAC |
| FIR 规格 | **1000 阶 (1001 tap)** 对称，16-bit 系数 / 12-bit 数据，40-bit 全精度 |

**数据流**:
```
ADC(12bit) → 减2048 → 有符号12-bit → FIR(40bit全精度)
    → >>> cal_shift (校准后的粗调)
    → × cal_coef (校准后的微调, Q1.15)
    → >>> 15 + 8192 → clamp [1,16382] → DAC 14bit
```

**与旧版区别**: 不再用固定 `>>14 + 8192` 硬编码缩放，而是用校准模式自动搜索出的最优 shift + coef。

---

## 五、DAC 输出多路复用

```verilog
if (use_fir_chain)          // bit[3] or bit[4]
    dac_out = cal_dac_signed clamped to [1, 16382]
else if (dds_mode)          // bit[2]
    dac_out = dds_dac_out
else                        // idle / ADC
    dac_out = 0
```

---

## 六、BRAM 地址空间分配

BRAM 32 位宽 × 128K 深度（512KB），真双端口：

| 地址范围（字节） | Port B 使用者 | 内容 |
|-----------------|--------------|------|
| `0x0000 ~ 0x3FFC` | ADC 采样器（写） | 4096 个采样点，每点 {ADC1[11:0], ADC2[11:0]} |
| `0x4010 ~ 0x47EC` | FIR 系数重载（读） | **506 个系数**，起始地址 16400，每系数取 `[31:16]` |
| 全部 | PS（Port A 读写） | 通过 AXI BRAM 控制器访问 |

---

## 七、时钟与复位架构

```
PS7 (FCLK_CLK0) ── 50MHz ──┬──> ODDR×3 ──> clk_out_adc_1/2, clk_out_dac
                            ├──> 所有 PL 子模块 (aclk)
                            └──> BRAM Port B (clkb)
```

**子模块复位**:

| 子模块 | `rst_n` 连接 | 效果 |
|--------|-------------|------|
| `adc_bram_sample` | `adc_bram_mode` | 未选中 = 复位 |
| `bram_read_fir_reload` | `fir_coef_reload_mode` | 同上 |
| `dds_10hz_2mhz` | `dds_mode` | 同上 |
| `fir_adc12_dac8` | `use_fir_chain`（同步后） | 校准或模仿时工作 |

---

## 八、模块实例化关系

```
Test_Top (top.v)
├── ODDR (×3)                        — ADC/DAC 时钟输出
├── adc_bram_sample                  — ADC 采样控制器
├── bram_read_fir_reload             — FIR 系数重载控制器 (506 coeffs)
├── fir_adc12_dac8                   — FIR 滤波封装 (1001 tap)
│   └── fir_compiler_0 (Xilinx IP)   — 1000阶对称 FIR, 40-bit 全精度
├── dds_10hz_2mhz                    — DDS 发生器
│   └── wave_rom (Xilinx IP)         — 8192×14bit 波形 ROM
├── shift + multiplier (组合逻辑)    — cal_shift + cal_coef (Q1.15)
├── FIR input MUX                    — 校准: DDS旁路 / 模仿: ADC
└── design_1_wrapper (BD)            — Zynq PS + AXI + BRAM
    ├── processing_system7_0         — ARM Cortex-A9
    ├── axi_smc                      — AXI SmartConnect
    ├── axi_bram_ctrl_0              — AXI BRAM 控制器
    ├── blk_mem_gen_0                — 双端口 BRAM (512KB)
    ├── AXI_Lite_PS_To_PL_PL_0       — 自定义 AXI-Lite 寄存器 (slv_reg0~3)
    └── rst_ps7_0_50M                — 复位模块
```

---

## 九、软件端 — 三阶段自动流程

基于 [helloworld.c](hello_world/src/helloworld.c)：

```
main()
  │
  ├─ 阶段1: 学习模式
  │    ├─ DDS + ADC: 扫频 488Hz→2MHz, 步进 488Hz, 4096 点
  │    ├─ ISR 驱动: 每 13.7ms 触发 → IQ 正交解调 → 幅相比 H(f)
  │    ├─ 输出: UART 打印 幅频(4096行) + 相频(4096行)
  │    ├─ find_peak(): 找最大幅值频点
  │    ├─ compute_fir_coefficients(): H(f) → 共轭对称 → CMSIS IFFT(8192)
  │    │    → fftshift → 截取 1001 tap → Hamming 窗 → 16-bit 量化
  │    └─ reload_fir_coefficients(): 按 reload_order 重排 → 写 BRAM → 触发重载
  │
  ├─ 阶段2: 校准模式
  │    ├─ DDS@峰值频率 → FIR → shift → mult → DAC → ADC_B 反馈
  │    ├─ 粗调: shift 31→0, IQ 比例法检测削顶 (A[s]/A[s+1] < 1.8)
  │    └─ 微调: coef 0xFFFF→0x0400, 匹配学习模式峰值幅值
  │
  └─ 阶段3: 模仿模式
       └─ ADC → FIR → shift → mult → DAC (用校准参数, 等效替代 RLC)
```

**关键参数**:
| 参数 | 值 | 说明 |
|------|-----|------|
| ADC 采样率 | 299.4 kHz | 50MHz / 167 |
| 扫频范围 | 488Hz ~ 2MHz | 步进 488Hz, 4096 点 |
| 单频测量 | IQ 正交解调 | 4096 点, ~0.2ms |
| FIR 阶数 | 1001 tap | 对称, 16-bit 系数 |
| FIR 采样率 | 1 MHz | 50MHz / 50 (DECIMATE_FIR) |
| 重载系数数 | 506 | reload_order 决定 |
| cal_shift | 0~31 | 粗调算术右移 |
| cal_coef | Q1.15 (0~2.0) | 微调乘数 |
