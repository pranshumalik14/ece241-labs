# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog poly_function.v

#load simulation using mux as the top level simulation module
vsim poly_calc

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets

## 
 # Sw[7:0] is data_in
 # KEY[0] synchronous reset when pressed
 # KEY[1] is go signal
 # LEDR displays result
 # HEX0 and HEX1 also display result
##

force clk 0 0ns, 1 {5ns} -r 10ns
#resetn
force resetn 0
force go 0
force data_in 0
run 10ns

# load A = 5
force resetn 1
force go 1
force data_in 8'd5
run 10ns

force resetn 1
force go 0
force data_in 8'd4
run 10ns

# load B = 4
force resetn 1
force go 1
force data_in 8'd4
run 10ns

force resetn 1
force go 0
force data_in 8'd3
run 10ns

# load C = 3
force resetn 1
force go 1
force data_in 8'd3
run 10ns

force resetn 1
force go 0
force data_in 8'd2
run 10ns

# load x = 2
force resetn 1
force go 1
force data_in 8'd2
run 10ns

force resetn 1
force go 0
force data_in 8'd0
run 10ns

# compute
run 40ns