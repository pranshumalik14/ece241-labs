# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in the verilog file to working dir
vlog AND.v

#load simulation using mux as the top level simulation module
vsim testAND

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# all test cases:

#set input values using the force command, signal names need to be in {} brackets
force {SW[0]} 0
force {SW[1]} 0
#run simulation for a few ns
run 10ns

force {SW[0]} 0
force {SW[1]} 1
run 10ns

force {SW[0]} 1
force {SW[1]} 0
run 10ns

force {SW[0]} 1
force {SW[1]} 1
run 10ns