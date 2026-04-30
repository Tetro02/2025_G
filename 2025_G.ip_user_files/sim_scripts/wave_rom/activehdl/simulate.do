transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+wave_rom  -L xil_defaultlib -L xilinx_vip -L xpm -L blk_mem_gen_v8_4_12 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.wave_rom xil_defaultlib.glbl

do {wave_rom.udo}

run 1000ns

endsim

quit -force
