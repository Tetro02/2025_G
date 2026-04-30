# auto_build.tcl
# Usage: source auto_build.tcl  (in Vivado Tcl Console)
#   or:  vivado -mode batch -source auto_build.tcl
#
# Automates: synthesis -> implementation -> bitstream -> export XSA
#
# Optimization notes:
#   - jobs  = number of parallel processes (set to 16 for 32-thread CPU)
#   - Use incremental implementation if previous run results are available


# ===== Configuration =====
set NUM_JOBS 16
set PROJECT 2025_G.xpr
set INCREMENTAL_DIR "./2025_G.runs/impl_1"
set INCREMENTAL_DCP "./2025_G.runs/impl_1/Test_Top_routed.dcp"


# ===== Build Process =====
open_project $PROJECT

# Step 1: Synthesis
puts "=== Step 1/4: Synthesis (jobs=$NUM_JOBS) ==="
reset_run synth_1
launch_runs synth_1 -jobs $NUM_JOBS
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "Synthesis failed!"
}
puts "[clock format [clock seconds] -format {%H:%M:%S}] Synthesis done."

# Step 2: Implementation with incremental check
puts "=== Step 2/4: Implementation (jobs=$NUM_JOBS) ==="

if {[file exists $INCREMENTAL_DCP]} {
    # Incremental implementation: reuses previous routed DCP as reference
    puts "  Incremental mode enabled (previous routed DCP found)."
    set_property STRATEGY Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
    launch_runs impl_1 -to_step write_bitstream -jobs $NUM_JOBS
} else {
    # Full implementation (first run)
    puts "  Full mode (no previous DCP, first build)."
    launch_runs impl_1 -to_step write_bitstream -jobs $NUM_JOBS
}

wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "Implementation failed!"
}
puts "[clock format [clock seconds] -format {%H:%M:%S}] Implementation done."

# Step 3: Bitstream (included in step 2)
puts "=== Step 3/4: Bitstream generated ==="

# Step 4: Export hardware platform with bitstream
puts "=== Step 4/4: Export XSA ==="
write_hw_platform -fixed -include_bit -force -file Test_Top.xsa
puts "=== Done! XSA exported: Test_Top.xsa ==="
puts "[clock format [clock seconds] -format {%H:%M:%S}] Build completed."
