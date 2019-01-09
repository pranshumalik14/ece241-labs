# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog mux2to1.v

# load simulation using the top level simulation module
vsim mux2to1

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# Test cases:

# set input values using the force command, signal names need to be in {} brackets
force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 0
# run simulation for a few ns
run 10ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 0
run 10ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 0
run 10ns

force {SW[0]} 1
force {SW[1]} 1
force {SW[9]} 0
run 10ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 1
run 10ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 1
run 10ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 1
run 10ns

force {SW[0]} 1
force {SW[1]} 1
force {SW[9]} 1
run 10ns