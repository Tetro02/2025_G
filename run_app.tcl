# ===== XSCT 一键烧录运行 =====
# 用法: xsct run_app.tcl
# 前提: Vivado 环境已初始化 (settings64.bat)

# 1. 连接目标
connect

# 2. 复位 + 配置 FPGA
targets -set -nocase -filter {name =~ "ARM*"}
rst -system
fpga -f "hello_world/_ide/bitstream/Test_Top.bit"

# 3. 下载 FSBL (初始化 PS / DDR)
source "platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/ps7_init.tcl"
ps7_init
ps7_post_config

# 4. 下载应用 ELF 并运行
dow "hello_world/build/hello_world.elf"
con
