vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_22
vlib modelsim_lib/msim/processing_system7_vip_v1_0_24
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/blk_mem_gen_v8_4_12
vlib modelsim_lib/msim/proc_sys_reset_v5_0_17
vlib modelsim_lib/msim/smartconnect_v1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_36
vlib modelsim_lib/msim/axi_bram_ctrl_v4_1_13

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_22 modelsim_lib/msim/axi_vip_v1_1_22
vmap processing_system7_vip_v1_0_24 modelsim_lib/msim/processing_system7_vip_v1_0_24
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_12 modelsim_lib/msim/blk_mem_gen_v8_4_12
vmap proc_sys_reset_v5_0_17 modelsim_lib/msim/proc_sys_reset_v5_0_17
vmap smartconnect_v1_0 modelsim_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_36 modelsim_lib/msim/axi_register_slice_v2_1_36
vmap axi_bram_ctrl_v4_1_13 modelsim_lib/msim/axi_bram_ctrl_v4_1_13

vlog -work xilinx_vip  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/Tetro/Tools/Vivado/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_22  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/b16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_24  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0_1/sim/design_1_processing_system7_0_0.v" \

vlog -work blk_mem_gen_v8_4_12  -incr -mfcu  "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/42f3/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_blk_mem_gen_0_0/sim/design_1_blk_mem_gen_0_0.v" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/sim/bd_afc3.v" \

vcom -work proc_sys_reset_v5_0_17  -93  \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/sim/bd_afc3_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/0848/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_2/sim/bd_afc3_arsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_3/sim/bd_afc3_rsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_4/sim/bd_afc3_awsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_5/sim/bd_afc3_wsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_6/sim/bd_afc3_bsw_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/3d9a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_7/sim/bd_afc3_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/7785/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_8/sim/bd_afc3_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/3051/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_9/sim/bd_afc3_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/852f/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_10/sim/bd_afc3_s00a2s_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_11/sim/bd_afc3_sarn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_12/sim/bd_afc3_srn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_13/sim/bd_afc3_sawn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_14/sim/bd_afc3_swn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_15/sim/bd_afc3_sbn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/fca9/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_16/sim/bd_afc3_m00s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_17/sim/bd_afc3_m00arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_18/sim/bd_afc3_m00rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_19/sim/bd_afc3_m00awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_20/sim/bd_afc3_m00wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_21/sim/bd_afc3_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/e44a/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_22/sim/bd_afc3_m00e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_23/sim/bd_afc3_m01s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_24/sim/bd_afc3_m01arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_25/sim/bd_afc3_m01rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_26/sim/bd_afc3_m01awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_27/sim/bd_afc3_m01wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_28/sim/bd_afc3_m01bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_29/sim/bd_afc3_m01e_0.sv" \

vcom -work smartconnect_v1_0  -93  \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.vhd" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.sv" \

vlog -work axi_register_slice_v2_1_36  -incr -mfcu  "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/bc4b/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L smartconnect_v1_0 -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/sim/design_1_axi_smc_0.sv" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0/sim/design_1_rst_ps7_0_50M_0.vhd" \

vcom -work axi_bram_ctrl_v4_1_13  -93  \
"../../../../2025_G.gen/sources_1/bd/design_1/ipshared/2f03/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_0_0/sim/design_1_axi_bram_ctrl_0_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/9a25/hdl" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../2025_G.gen/sources_1/bd/design_1/ipshared/00fe/hdl/verilog" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/Tetro/Tools/Vivado/2025.2/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/3e94/hdl/AXI_Lite_PS_To_PL_PL_slave_lite_v1_0_S00_AXI.v" \
"../../../bd/design_1/ipshared/3e94/hdl/AXI_Lite_PS_To_PL_PL.v" \
"../../../bd/design_1/ip/design_1_AXI_Lite_PS_To_PL_PL_0_0/sim/design_1_AXI_Lite_PS_To_PL_PL_0_0.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

