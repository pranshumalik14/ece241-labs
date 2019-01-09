# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog mux7to1.v

# load simulation using the top level simulation module
vsim lab3Part1

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# corner cases:
# objective for cases 1 through 2: show flipping of input and selection of correct input

# case 1: MuxSelect = {0, 0, 0} ; Expected output 0
force {SW[9]} 0
force {SW[8]} 0
force {SW[7]} 0

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
run 10ns

# case 2: MuxSelect = {0, 0, 0} ; Expected output 1
force {SW[9]} 0
force {SW[8]} 0
force {SW[7]} 0

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
run 10ns

# objective for cases 3 through 5: testing rest of corner cases

# case 3: MuxSelect = {1, 1, 0} ; Expected output 1
force {SW[9]} 1
force {SW[8]} 1
force {SW[7]} 0

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 1
run 10ns

# case 4: MuxSelect = {1, 1, 1} ; Expected output 0
force {SW[9]} 1
force {SW[8]} 1
force {SW[7]} 1

force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
run 10ns

# objective for case 5 through 6: testing middle cases

# case 5: MuxSelect = {0, 1, 1} ; Expected output 1
force {SW[9]} 0
force {SW[8]} 1
force {SW[7]} 1

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
run 10ns

# case 6: MuxSelect = {1, 0, 0} ; Expected output 0 (with random, mixed inputs)
force {SW[9]} 1
force {SW[8]} 0
force {SW[7]} 0

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 1
run 10ns