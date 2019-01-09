# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog universal_ShiftRegister.v

# load simulation using the top level simulation module
vsim universal_ShiftReg

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

## 
 # DATA_IN is the data input bus
 # reset is the reset
 # clock is the clock signal
 # ParallelLoad_n is the parallel load input mode
 # rotateRight is the rotate right mode
 # LSRight is the logical shift right mode				 
 # Q_out is the register output bus
##

force clock 0
force reset 0

force ParallelLoad_n 0
force rotateRight 0
force LSRight 0

force DATA_IN 11010000
run 10ns

# Case 1: Loading values onto the LEDs with poitive edge of clock
force clock 1
run 10ns

# Case 2: Rotating the bits to the left two times, so we have four clock cycles
# setting parallel load to 0 to allow rotation of bits
force ParallelLoad_n 1
force clock 0
run 10ns

force clock 1
run 10ns

force clock 0
run 10ns

force clock 1
run 10ns

# Case 3: Testing the reset switch
force reset 1
force clock 0
run 10ns

force clock 1
run 10ns

#  Case 4: Loading a new value onto the LEDs and then rotating to the right without LSRight active
force DATA_IN 00001011

force ParallelLoad_n 0
force clock 0
force reset 0
run 10ns

force clock 1
run 10ns

force ParallelLoad_n 1
force rotateRight 1
force clock 0
run 10ns


force clock 1
run 10ns

force clock 0
run 10ns

force clock 1
run 10ns

# Case 5: Testing Logical Shift Right leftmost bits should be replaced by 0
force DATA_IN 00001011

force ParallelLoad_n 0
force clock 0
force LSRight 1
run 10ns

force clock 1
run 10ns

force ParallelLoad_n 1
force rotateRight 1
force clock 0
run 10ns


force clock 1
run 10ns

force clock 0
run 10ns

force clock 1
run 10ns