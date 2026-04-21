transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_22
vlib riviera/processing_system7_vip_v1_0_24
vlib riviera/xil_defaultlib
vlib riviera/blk_mem_gen_v8_4_12
vlib riviera/proc_sys_reset_v5_0_17
vlib riviera/smartconnect_v1_0
vlib riviera/axi_register_slice_v2_1_36
vlib riviera/axi_bram_ctrl_v4_1_13

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_22 riviera/axi_vip_v1_1_22
vmap processing_system7_vip_v1_0_24 riviera/processing_system7_vip_v1_0_24
vmap xil_defaultlib riviera/xil_defaultlib
vmap blk_mem_gen_v8_4_12 riviera/blk_mem_gen_v8_4_12
vmap proc_sys_reset_v5_0_17 riviera/proc_sys_reset_v5_0_17
vmap smartconnect_v1_0 riviera/smartconnect_v1_0
vmap axi_register_slice_v2_1_36 riviera/axi_register_slice_v2_1_36
vmap axi_bram_ctrl_v4_1_13 riviera/axi_bram_ctrl_v4_1_13

vlog -work xilinx_vip  -incr "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -v2k5 "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_22  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/b16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_24  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_processing_system7_0_0_1/sim/design_1_processing_system7_0_0.v" \

vlog -work blk_mem_gen_v8_4_12  -incr -v2k5 "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/42f3/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_blk_mem_gen_0_0/sim/design_1_blk_mem_gen_0_0.v" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/sim/bd_afc3.v" \

vcom -work proc_sys_reset_v5_0_17 -93  -incr \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/sim/bd_afc3_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/0848/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_2/sim/bd_afc3_arsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_3/sim/bd_afc3_rsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_4/sim/bd_afc3_awsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_5/sim/bd_afc3_wsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_6/sim/bd_afc3_bsw_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/3d9a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_7/sim/bd_afc3_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/7785/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_8/sim/bd_afc3_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/3051/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_9/sim/bd_afc3_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/852f/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_10/sim/bd_afc3_s00a2s_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_11/sim/bd_afc3_sarn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_12/sim/bd_afc3_srn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_13/sim/bd_afc3_sawn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_14/sim/bd_afc3_swn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_15/sim/bd_afc3_sbn_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/fca9/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_16/sim/bd_afc3_m00s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_17/sim/bd_afc3_m00arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_18/sim/bd_afc3_m00rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_19/sim/bd_afc3_m00awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_20/sim/bd_afc3_m00wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_21/sim/bd_afc3_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/e44a/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_22/sim/bd_afc3_m00e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_23/sim/bd_afc3_m01s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_24/sim/bd_afc3_m01arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_25/sim/bd_afc3_m01rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_26/sim/bd_afc3_m01awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_27/sim/bd_afc3_m01wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_28/sim/bd_afc3_m01bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_29/sim/bd_afc3_m01e_0.sv" \

vcom -work smartconnect_v1_0 -93  -incr \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.vhd" \

vlog -work smartconnect_v1_0  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.sv" \

vlog -work axi_register_slice_v2_1_36  -incr -v2k5 "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/bc4b/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/ip/design_1_axi_smc_0/sim/design_1_axi_smc_0.sv" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0/sim/design_1_rst_ps7_0_50M_0.vhd" \

vcom -work axi_bram_ctrl_v4_1_13 -93  -incr \
"../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/2f03/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_0_0/sim/design_1_axi_bram_ctrl_0_0.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../7020_BRAM_ADC.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 -l axi_bram_ctrl_v4_1_13 \
"../../../bd/design_1/sim/design_1.v" \
"../../../bd/design_1/ipshared/3e94/hdl/AXI_Lite_PS_To_PL_PL_slave_lite_v1_0_S00_AXI.v" \
"../../../bd/design_1/ipshared/3e94/hdl/AXI_Lite_PS_To_PL_PL.v" \
"../../../bd/design_1/ip/design_1_AXI_Lite_PS_To_PL_PL_0_0/sim/design_1_AXI_Lite_PS_To_PL_PL_0_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

