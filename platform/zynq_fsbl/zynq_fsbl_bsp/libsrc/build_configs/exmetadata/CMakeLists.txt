
cmake_minimum_required(VERSION 3.15)
project(bsp)

# Use CMAKE_LIBRARY_PATH in link_directories
link_directories(${CMAKE_LIBRARY_PATH})
        
set(DRIVER_TARGETS bram;coresightps_dcc;devcfg;dmaps;scugic;qspips;scutimer;scuwdt;uartps;xadcps)
set(DRIVER_LOCATIONS D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/bram_v4_13;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/coresightps_dcc_v1_13;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/devcfg_v3_9;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/dmaps_v2_11;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/scugic_v5_6;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/qspips_v3_14;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/scutimer_v2_7;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/scuwdt_v2_6;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/uartps_v3_17;D:/Tetro/Tools/Vivado/2025.2/Vitis/data/embeddedsw/XilinxProcessorIPLib/drivers/xadcps_v2_7)

list(LENGTH DRIVER_TARGETS no_of_drivers)
set(index 0)

while(${index} LESS ${no_of_drivers})
    list(GET DRIVER_TARGETS ${index} drv)
    list(GET DRIVER_LOCATIONS ${index} drv_dir)
    set(exp_dir "${drv_dir}/examples")
    add_custom_target(
        ${drv}_example ALL
        COMMAND lopper -f -O C:/Users/Tetro/Documents/FPGA_Project/2025_G/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/${drv} C:/Users/Tetro/Documents/FPGA_Project/2025_G/platform/zynq_fsbl/zynq_fsbl_bsp/hw_artifacts/ps7_cortexa9_0_baremetal.dts -- bmcmake_metadata_xlnx ps7_cortexa9_0 ${exp_dir} drvcmake_metadata
        BYPRODUCTS x${drv}_exlist.yaml)
    MATH(EXPR index "${index}+1")
endwhile()
