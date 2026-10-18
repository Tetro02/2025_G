# 复现步骤

## Vivado

使用 Vivado / Vitis **2025.2** 并安装 Zynq-7000 器件支持。Windows 建议短目录（如 `C:/fpga/2025_G`），防止生成文件路径超限。

从仓库根目录运行：

```text
python scripts/check_sources.py
vivado -mode batch -source scripts/prepare_vivado.tcl
```

脚本打开 XPR、更新本地 IP 目录、校验 BD、生成 wrapper、独立 FIR/波形 ROM 输出并更新编译顺序。完整构建：

```text
vivado -mode batch -source scripts/prepare_vivado.tcl -tclargs build
```

成功后导出 `build/Test_Top.xsa`；脚本不复位或烧录开发板。旧 `auto_build.tcl` 已改为调用这个入口，避免跳过缺失 IP/wrapper 的准备步骤。

## Vitis

1. 从本轮 XSA 新建 platform，CPU `ps7_cortexa9_0`、OS standalone，重新生成 BSP。
2. 新建 Hello World 应用，导入 `hello_world/src`，保留 `helloworld.c`、`platform.c`、头文件和 `libCMSISDSP.a`。
3. 参考 `UserConfig.cmake`：include `CMSIS_DSP`，链接 `CMSISDSP` 与 `m`，库目录指向应用 src。使用 Cortex-A9、VFPv3、hard-float，确保静态库 ABI 与应用匹配。
4. 由新平台生成 BSP/linker 配置，不复用旧机器的 compile_commands 或 app.yaml。
5. 构建 ELF；调试时硬件、bitstream 和 ELF 应来自同一平台版本。SD 启动时自行用匹配的 FSBL/bitstream/ELF 生成 BOOT.BIN。

本仓库的 CMSIS 静态库来自原工程，确切上游提交和编译参数未追溯；可从 Arm 官方源码按实际 ABI 重建，但本次没有验证完整静态库重建流程。

## 初始系数恢复

原工程引用桌面 `20000D_1M_1000.coe`，现已缺失。发布副本采用本地 `2026_FIR` 导入目录内同名、生成日期 2026-06-02 的 1001 系数文件，保存在 `coefficients/`，并在来源清单明确记录。它是 IP 生成时的初始系数；正常运行会用学习结果重载，不等同于当前被测电路的学习系数。与原生成物的一致性检查见验证记录。
