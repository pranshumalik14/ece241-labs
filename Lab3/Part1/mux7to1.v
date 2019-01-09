`timescale 1ns / 1ns // `timescale time_unit/time_precision


/* top-level entity for 7 to 1 multiplexer */
module lab3Part1 (input [9:0] SW, output [0:0] LEDR);
				
				/* 
				 * SW[6:0] are the data inputs
				 * SW[9:7] are the select signals
				 * LEDR[0] is the output
				 */
				 
				mux7to1 C1 (.Input(SW[6:0]), .MuxSelect(SW[9:7]), .Out(LEDR[0]));
				
endmodule // lab3Part1


/* 7 to 1 multiplexer module */
module mux7to1 (input [6:0] Input, input [2:0] MuxSelect, output Out);
				
				reg muxOut; // output of the always block
				
				/*
				 * always statement implementing the 
				 * the combinational logic for selecting signals
				 */
				
				always @(*)
				begin
					case (MuxSelect[2:0])
					
						3'b000: muxOut = Input[0]; // input signal 1
						3'b001: muxOut = Input[1]; // input signal 2
						3'b010: muxOut = Input[2]; // input signal 3
						3'b011: muxOut = Input[3]; // input signal 4
						3'b100: muxOut = Input[4]; // input signal 5
						3'b101: muxOut = Input[5]; // input signal 6
						3'b110: muxOut = Input[6]; // input signal 7
						default: muxOut = 1'b0; // default case
					
					endcase
				end
				
				assign Out = muxOut;
				
endmodule // mux7to1