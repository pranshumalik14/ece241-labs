# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog morseCode_Generator.v

# load simulation using the top level simulation module
vsim morseCode_Generator

# log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force reset 0
force msg_Send 1
force alphabet 000
force clock 0 0ns , 1 {5ns} -r 10ns
run 20 ns

force reset 1
force msg_Send 0
force alphabet 000
force clock 0 0ns , 1 {5ns} -r 10ns
run 40 ns

force reset 1
force msg_Send 1
force alphabet 001
force clock 0 0ns , 1 {5ns} -r 10ns
run 120 ns

force reset 1
force msg_Send 0
force alphabet 001
force clock 0 0ns , 1 {5ns} -r 10ns
run 40 ns

force reset 1
force msg_Send 1
force alphabet 001
force clock 0 0ns , 1 {5ns} -r 10ns
run 100 ns