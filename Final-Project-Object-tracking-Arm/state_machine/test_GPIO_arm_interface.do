# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog GPIO_arduino_interface.v

#load simulation using mux as the top level simulation module
vsim GPIO_Arduino

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force clock_50 0 0ns, 1 {2.5ns} -r 5ns
#resetn
force reset 1
force object_found 0
run 50ns

force reset 0
force object_found 0
run 2000000000ns


force reset 0
force object_found 1
run 5000ns

force reset 0
force object_found 0
run 50ns

force reset 0
force object_found 0
run 500ns