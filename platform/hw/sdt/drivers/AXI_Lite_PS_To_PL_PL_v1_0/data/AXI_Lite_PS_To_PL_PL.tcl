

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AXI_Lite_PS_To_PL_PL" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR"
}
