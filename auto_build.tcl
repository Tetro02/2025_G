# Compatibility entry: prepare IP, build hardware, and export XSA. No board writes.
set argv {build}
source [file join [file dirname [info script]] scripts prepare_vivado.tcl]
