# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog fullAdder.v

# load simulation using the top level simulation module
vsim lab3Part2

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

### 
 # SW[3:0] is the input B bus
 # SW[7:4] is the input A bus
 # SW[8] is the carry-in bit
 # LEDR[3:0] is the sum bus
 # LEDR[9] is the carry-out bit
###

# test cases:
# objective for cases 1 through 4: validate functionality of carry-in and carry-out pins

# case 1 testing c_in: A = 0, B = 0, c_in = 1 ; Expected output S = 1, c_out = 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0

force {SW[8]} 1
run 10ns

# case 2 testing c_out: A = 8, B = 8, c_in = 0; Expected output S = 16, c_out = 1 
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0

force {SW[8]} 0
run 10ns

# case 3 testing c1: A = 1, B = 1, c_in = 0; Expected output S = 2, c_out = 0 
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1

force {SW[8]} 0
run 10ns

# case 4 testing c2: A = 2, B = 2, c_in = 0; Expected output S = 4, c_out = 0 
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0

force {SW[8]} 0
run 10ns

# case 5 testing c3: A = 4, B = 4, c_in = 0; Expected output S = 8, c_out = 0 
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 0

force {SW[8]} 0
run 10ns

# case 6 random, mix inputs: A = 15, B = 15, c_in = 1; Expected output S = 15, c_out = 1 
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1

force {SW[8]} 1
run 10ns

# case 7 random, mix inputs: A = 9, B = 6, c_in = 0; Expected output S = 15, c_out = 0 
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 0

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1

force {SW[8]} 0
run 10ns