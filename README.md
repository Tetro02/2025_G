# 2025 电赛 G 题 电路模型探究装置

基于 **XC7Z020CLG484-1（Zynq-7020）** 的学习、校准与模仿工程。PL 完成 DDS 激励、双路 ADC 采样、BRAM 缓存、可重载 FIR 和 DAC 输出；PS 测量双通道传递函数，计算最小相位 FIR 系数并控制校准。

当前基线为 **2026-06-12 的 `0c07eab`**，属于对 2025 年 G 题的后续实现/学习版本；提交时间不代表比赛验收时间。项目未附成绩或完整测试记录，不宣称竞赛全部指标通过，也不沿用 2026 G 题的赛区及硬件配置。

## 工作链路

```text
学习：DDS → 待测电路 → ADC1（输出）
          └────────→ ADC2（参考输入）
双路 ADC → BRAM → PS IQ 解调 → H = ADC1 / ADC2
       → 幅度后处理 → 倒谱法最小相位 FIR → 1008 字系数重载
校准：DDS → FIR → shift → Q1.15 微调 → DAC → ADC 反馈
模仿：ADC2 → FIR（1 MS/s 有效输入）→ shift → 微调 → DAC
```

学习完成后程序提示 **7 秒内断开外接滤波器、改为校准直连链路**。接线需根据实际模块核对，说明见 [操作与硬件](docs/hardware.md)。

## 目录和使用

| 文件/目录 | 用途 |
|---|---|
| `2025_G.xpr` / `2025_G.srcs/` | Vivado 工程、RTL、BD、独立 IP 配置、引脚约束 |
| `hello_world/src/` | Vitis 裸机应用、CMSIS 头文件/静态库、调试备用系数 |
| `ip_repo/` | 原工程缺失的自定义 AXI-Lite IP |
| `coefficients/` | 可移植的 FIR 初始 COE 文件 |
| `docs/architecture.md` | 当前寄存器、采样率、非对称 FIR 与重载布局 |
| `docs/build.md` | Vivado / Vitis 2025.2 复现步骤 |
| `docs/validation.md` | 检查结果、已修复问题及未验证范围 |
| `docs/history/` | 保留的 6 月 2 日历史模式笔记，含旧参数与旧链接 |
| `scripts/` | 依赖检查、Vivado 准备/构建脚本 |

先阅读 [复现步骤](docs/build.md)，再运行 `python scripts/check_sources.py`。准备 Vivado 工程：

```text
vivado -mode batch -source scripts/prepare_vivado.tcl
```

加 `-tclargs build` 可执行综合、实现并导出 XSA。准备脚本不连接硬件。`run_app.tcl` 是会复位、配置并运行开发板的旧调试脚本，使用前须核对实际 PS 初始化文件和 bitstream/ELF，不能当作已验证的一键启动器。

## 本次整理

补齐自定义 IP、初始系数和重载顺序记录；移除 IDE、BOOT.bin、机器编译缓存和失效桌面路径；禁用旧 DCP 增量依赖。修正 1001 tap 数组在 1008 字重载/打印时的越界读取，多出的 7 字填零，未修改 FIR 学习/校准算法，未烧录硬件。详见 [验证记录](docs/validation.md)。

原创内容采用 [MIT](LICENSE)；Arm/AMD 内容以 [第三方声明](THIRD_PARTY_NOTICES.md)和文件原有许可为准。
