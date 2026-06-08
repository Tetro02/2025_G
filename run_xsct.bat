@echo off
title XSCT Run
chcp 65001 >nul
call D:\Tetro\Tools\Vivado\2025.2\Vivado\settings64.bat

echo ========================================
echo   XSCT: 烧录 + 运行 (绕过 Vitis GUI)
echo ========================================

xsct -eval "
connect
puts \"[INFO] 已连接目标\"

targets -set -nocase -filter {name =~ \"ARM*\"}
rst -system
puts \"[INFO] 系统复位完成\"

after 2000
fpga -f hello_world/_ide/bitstream/Test_Top.bit
puts \"[INFO] FPGA 配置完成\"

source platform/export/platform/hw/ps7_init.tcl
ps7_init
ps7_post_config
puts \"[INFO] PS7 初始化完成\"

dow hello_world/build/hello_world.elf
puts \"[INFO] ELF 下载完成\"

con
puts \"[INFO] 程序运行中... (Ctrl+C 停止)\"
"
pause
