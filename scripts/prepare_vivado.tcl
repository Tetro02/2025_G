set root [file normalize [file join [file dirname [info script]] ..]]
set project [file join $root 2025_G.xpr]
open_project $project
update_ip_catalog
set bd [get_files design_1.bd]
open_bd_design $bd
validate_bd_design
generate_target all $bd
set wrapper [make_wrapper -files $bd -top]
add_files -norecurse $wrapper
generate_target all [get_ips {wave_rom fir_compiler_0}]
update_compile_order -fileset sources_1
file mkdir [file join $root build]
report_ip_status -file [file join $root build ip-status.txt]
if {[llength $argv] && [lindex $argv 0] eq "build"} {
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "Synthesis failed"}
    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1
    if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Implementation failed"}
    file mkdir [file join $root build]
    write_hw_platform -fixed -include_bit -force -file [file join $root build Test_Top.xsa]
}
close_project
