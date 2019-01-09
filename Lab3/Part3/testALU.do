# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog ALU.v

# load simulation using the top level simulation module
vsim lab3Part3

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

### 
 # SW[3:0] is the input B bus
 # SW[7:4] is the input A bus
 # KEY[2:0] is the operation selection bus
 # LEDR[7:0] is the ALU output bus
 # HEX0, HEX2, HEX4, HEX5 are for display of inputs and output
 # HEX1 and HEX3 stay off (un-initialized)
###

# test cases to validate functionality of ALU

# case 1:
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

# case 2:
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

# case 3:
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

# case 4:
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

# case 5:
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns

# case 6:
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns

# case 7:
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns

# case 8:
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns

# case 9:
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

# case 10:
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

# case 11:
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

# case 12:
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0

force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns