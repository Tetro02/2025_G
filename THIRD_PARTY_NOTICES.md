# 第三方声明

原创部分及本次说明采用根目录 MIT 许可；第三方代码、模板、标准 IP 和历史生成物保留其原许可，不作重新授权。

- `hello_world/src/CMSIS_DSP/`：Arm CMSIS-DSP / CMSIS Core，文件标记 Apache-2.0，全文见 `LICENSES/Apache-2.0.txt`。
- `libCMSISDSP.a`：原工程已有静态库，确切上游提交和构建参数未核实。官方源码为 https://github.com/ARM-software/CMSIS-DSP 和 https://github.com/ARM-software/CMSIS_5 。
- Vitis platform、CMake、linker 等模板：AMD/Xilinx，按各文件原版权/SPDX 声明使用。
- `ip_repo`：从本地原 AXI-Lite IP 收集，基于 Vivado 模板；模板部分遵循 AMD 条款，用户修改部分遵循项目许可。
- Vivado 标准 IP：仅保留配置和必要参考输出；生成和使用须具备对应工具/IP 使用权。
- FIR reload_order 文件：原工程工具输出，用于核对软件的重载布局；不代表重新许可 AMD IP 实现。

没有把工具安装包、供应商整套资料或 2026 G 题报告加入本仓库。
