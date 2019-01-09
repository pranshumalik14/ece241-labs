# set the working dir, where all compiled verilog goes
vlib  work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog eightBit_Counter.v

#load simulation using mux as the top level simulation module
vsim eightBit_Counter

#log all signals and add some signals to waveform window
log {/*}

# add wave {/*} would add all items in top level simulation module
add wave {/*}

force clear 0
force enable 1

force clock 0

run 10ns

force clock 1

run 10ns

force clear 1
force enable 1

force clock 0

run 10ns

force clock 1

run 10ns

force clock 0

run 10ns

force clock 1

run 10ns

force clock 0

run 10ns

force clock 1

run 10ns

force clock 0

run 10ns

force clock 1

run 10ns

force enable 0

force clock 0

run 10ns

force clock 1

run 10ns

force clock 0

run 10ns

force clock 1

run 10ns

force clear 0

force clock 0

run 10ns

force clock 1

run 10ns

