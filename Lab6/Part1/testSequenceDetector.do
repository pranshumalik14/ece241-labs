# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog sequence_detector.v

# load simulation using the top level simulation module
vsim sequence_detector

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

##
 # {SW[0]} reset when 0
 # {SW[1]} input signal
 # {KEY[0]} clock signal
 # LEDR[3:0] displays current state
 # LEDR[9] displays output
##

#case 1 - reset
force {SW[0]} 0
force {KEY[0]} 1
force {SW[1]}  0
run 5ns

force {SW[0]} 0
force {KEY[0]} 0
run 5ns

#case 2 - loading in the value 1 4 times consecutively
force {SW[1]} 1
force {SW[0]} 1
force {KEY[0]} 0
run 5ns

force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

#now when clock is switched ON - LEDR[9] should be on 
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

#now when clock is switched ON - LEDR[9] should still be on cause it ovelaps and gets a new s
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

#setting the w input to 0, then to 1 and checking the output light again (should be 1)

force {SW[1]} 0
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

force {SW[1]} 1
force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns

force {KEY[0]} 1
run 5ns
force {KEY[0]} 0
run 5ns
# after the above run the z output shiuld be 1(LEDR[9] should be ON)