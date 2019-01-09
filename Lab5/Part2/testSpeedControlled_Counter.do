# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog speedControlled_Counter.v

# load simulation using the top level simulation module
vsim speedController

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force reset 0
force f_Select 00
force clock 0 0ns , 1 {5ns} -r 10ns
run 20 ns

force reset 1
force f_Select 01
force clock 0 0ns , 1 {5ns} -r 10ns
run 2000 ns

force reset 1
force f_Select 00
force clock 0 0ns , 1 {5ns} -r 10ns
run 200 ns