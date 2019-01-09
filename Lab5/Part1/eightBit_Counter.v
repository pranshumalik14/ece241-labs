`timescale 1ns / 1ns // `timescale time_unit/time_precision

/* top-level entity for the 8-bit counter */
module lab5Part1 (input [1:0] SW, input [0:0] KEY, output [9:0] LEDR, 
						output [6:0] HEX0, HEX1);
				
				assign LEDR[9:0] = 10'b0000000000; // all LEDs remain off
				wire [7:0] Q_state; // current state of the counter circuit
				
				/* 
				 * KEY[0] is the clock signal
				 * SW[0] is the clear signal
				 * SW[1] is the enable signal
				 * HEX0, HEX1 are for display of inputs and output
				 * Rest HEX[k] stay off (un-initialized)
				 */
				 
				 eightBit_Counter C1 (.clock(~KEY[0]), .clear(SW[0]), 
											.enable(SW[1]), .Q(Q_state)); // instantiating 8-bit counter
				 
				 BCD_to_HEX_Decoder D1 (.C(Q_state[3:0]), .HEX(HEX0)); // display LSB of Q
				 BCD_to_HEX_Decoder D2 (.C(Q_state[7:4]), .HEX(HEX1)); // display MSB of Q
				
endmodule // lab5part1

/* 8-bit counter using 8 serial t_flip-flops */
module eightBit_Counter (input clock, clear, enable, output [7:0] Q);

				wire [7:0] T; // (N-1) = 7-bit bus to track toggle inputs. T[0] not used
				t_flipFlop T0 (.T(enable), .clock(clock), .clear(clear), .Q(Q[0]), .Q_p1(T[1])); // bit 0
				t_flipFlop T1 (.T(T[1]), .clock(clock), .clear(clear), .Q(Q[1]), .Q_p1(T[2])); // bit 1
				t_flipFlop T2 (.T(T[2]), .clock(clock), .clear(clear), .Q(Q[2]), .Q_p1(T[3])); // bit 2
				t_flipFlop T3 (.T(T[3]), .clock(clock), .clear(clear), .Q(Q[3]), .Q_p1(T[4])); // bit 3
				t_flipFlop T4 (.T(T[4]), .clock(clock), .clear(clear), .Q(Q[4]), .Q_p1(T[5])); // bit 4
				t_flipFlop T5 (.T(T[5]), .clock(clock), .clear(clear), .Q(Q[5]), .Q_p1(T[6])); // bit 5
				t_flipFlop T6 (.T(T[6]), .clock(clock), .clear(clear), .Q(Q[6]), .Q_p1(T[7])); // bit 6
				t_flipFlop T7 (.T(T[7]), .clock(clock), .clear(clear), .Q(Q[7]), .Q_p1(T[0])); // bit 7

endmodule // eightBit_Counter

/* t-flip flop module with asynchronous clear */
module t_flipFlop (input T, clock, clear, output reg Q, Q_p1);

				// triggered on rising edge of the clock signal and falling edge of clear
				always @(posedge clock, negedge clear)
				begin
				
					if (clear == 1'b0)
						Q <= 1'b0; // active-low, asynchronous reset to 0
					else if (T == 1'b0)
						Q <= Q; // if toggle is 0, t_flip-flop maintains state
					else
						Q <= ~Q; // if toggle is 1, t_flip-flop changes state to T' 
						
					Q_p1 = Q & T; // T for the next t_flip-flop
					
				end

endmodule // t_flipFlop


/* BCD to common-anode seven-segment display decoder */
module BCD_to_HEX_Decoder (input [3:0] C, output [6:0] HEX);

				// maxterms for every segment LEDs with common anode
				assign HEX[0] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|!C[0]));
								
				assign HEX[1] = !((C[3]|!C[2]|C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|C[0]) & 
								(!C[3]|C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|!C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]));
								
				assign HEX[2] = !((C[3]|C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|!C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]));
								
				assign HEX[3] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|!C[2]|C[1]|C[0]) & 
								(C[3]|!C[2]|!C[1]|!C[0]) & (!C[3]|C[2]|C[1]|!C[0]) & 
								(!C[3]|C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]));
								
				assign HEX[4] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|C[2]|!C[1]|!C[0]) & 
								(C[3]|!C[2]|C[1]|C[0]) & (C[3]|!C[2]|C[1]|C[0]) &
								(C[3]|!C[2]|C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|!C[0]) &
								(!C[3]|C[2]|C[1]|!C[0]));
								
				assign HEX[5] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|C[2]|!C[1]|C[0]) & 
								(C[3]|C[2]|!C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|!C[0]) & 
								(!C[3]|!C[2]|C[1]|!C[0]));
								
				assign HEX[6] = !((C[3]|C[2]|C[1]|C[0]) & (C[3]|C[2]|C[1]|!C[0]) & 
								(C[3]|!C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|C[0]));

endmodule // BCD_to_HEX_Decoder