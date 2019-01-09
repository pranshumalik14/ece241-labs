`timescale 1ns / 1ns // `timescale time_unit/time_precision


/* top-level entity for ALU */
module lab4Part2 (input [9:0] SW, input [3:0] KEY, 
						output [9:0] LEDR, output [6:0] HEX0, HEX4, HEX5);

				assign LEDR[9:8] = 2'b00; // LEDR[9] and LEDR[8] are off
				wire [7:0] ALUout, regState;
				
				/* 
				 * SW[3:0] is the input A bus
				 * SW[9] is the reset
				 * KEY[0] is the clock signal
				 * KEY[3:1] is the operation selection bus
				 * LEDR[7:0] is the ALU output bus
				 * HEX0, HEX4, HEX5 are for display of inputs and output
				 * HEX1, HEX2, and HEX3 stay off (un-initialized)
				 * SW[8:4] are non-inputs for any function
				 */
				
				bcdDecoder disp_A (.C(SW[3:0]), .HEX(HEX0)); // display input A
				
				ALU A1 (.A(SW[3:0]), .B(regState[3:0]), .regState(regState), 
						.opSelect(KEY[3:1]), .ALUout(ALUout)); // instantiating ALU
				regALU R1 (.regInput(ALUout), .reset(SW[9]), .clock(~KEY[0]), 
						.regState(regState)); // instantiating register
				
				assign LEDR[7:0] = regState; // display register state bus
				bcdDecoder disp_regState_1 (.C(regState[3:0]), .HEX(HEX4)); // display on HEX4
				bcdDecoder disp_regState_2 (.C(regState[7:4]), .HEX(HEX5)); // display on HEX5
				
endmodule // lab4Part2


/* register to store output from the ALU */
module regALU (input [7:0] regInput, input reset, clock, 
					output reg [7:0] regState);

	always @(posedge clock) // triggered on rising edge of the clock signal
	begin
	
		if (reset == 1'b0) // active-low, clock synchronous reset to 0
			regState <= 8'b00000000;
		else 
			regState <= regInput; // if reset is not 0, register stores input
	
	end

endmodule // regALU

/* Arithmetic Logic Unit with 8 possible operations */
module ALU (input [3:0] A, B, input [2:0] opSelect, input [7:0] regState, 
				output [7:0] ALUout);
				
				wire [7:0] opOut_0, opOut_1, opOut_2, opOut_3, opOut_4, 
							opOut_5, opOut_6, opOut_7; // 7 8-bit possible outputs of the ALU
				
				// case 0
				fourBitAdder FA_4bit (.A(A), .B(B), .c_in(1'b0), .S(opOut_0[3:0]), 
								.c_out(opOut_0[4])); // modular addition
				assign opOut_0[7:5] = 3'b000; // pad the rest bits to zero
				
				// case 1
				assign opOut_1[4:0] = (A + B); // bitwise addition operator
				assign opOut_1[7:5] = 3'b000; // pad the rest bits to zero
				
				// case 2
				assign opOut_2[3:0] = ~(A & B); // bitwise nand
				assign opOut_2[7:4] = ~(A | B); // bitwise nor
				
				// case 3
				assign opOut_3 = ((A > 0) | (B > 0)) ? (8'b11000000):(8'b00000000);
				
				// case 4
				assign opOut_4 = (((~^A) & (A != 0) & (A != 15)) & // returns 1 if A has 2 ones
									((^B) & (B >= 7) & (B != 8))) // returns 1 if B has 3 ones
									? (8'b00111111):(8'b00000000);
				
				// case 5
				assign opOut_5[7:4] = B; // B as MSB
				assign opOut_5[3:0] = ~A; // complement of A as LSB
				
				// case 6
				assign opOut_6[3:0] = ~(A ^ B); // bitwise xnor
				assign opOut_6[7:4] = (A ^ B); // bitwise xor
				
				// case 7
				assign opOut_7 = regState; // register values remain unchanged
				
				// selecting which operation to output using a 7 to 1 multiplexer
				mux7to1 opSelecter_1 (.out0(opOut_0), .out1(opOut_1), .out2(opOut_2), 
											.out3(opOut_3), .out4(opOut_4), .out5(opOut_5), 
											.out6(opOut_6), .out7(opOut_7), 
											.MuxSelect(opSelect), .muxOut(ALUout));

endmodule //ALU


/* 7 to 1 multiplexer module */
module mux7to1 (input [7:0] out0, out1, out2, out3, out4, out5, out6, out7,  
					input [2:0] MuxSelect, output reg [7:0] muxOut);
				
				/*
				 * always statement implementing the 
				 * the combinational logic for selecting signals
				 */
				
				always @(*)
				begin
					case (~MuxSelect[2:0])
						
						// inverted MuxSelect bits for input through KEY
						3'b000: muxOut = out0; // output of operation 0
						3'b001: muxOut = out1; // output of operation 1
						3'b010: muxOut = out2; // output of operation 2
						3'b011: muxOut = out3; // output of operation 3
						3'b100: muxOut = out4; // output of operation 4
						3'b101: muxOut = out5; // output of operation 5
						3'b110: muxOut = out6; // output of operation 6
						3'b111: muxOut = out7; // output of operation 7
						default: muxOut = 8'b00000000; // default case
					
					endcase
				end
				
endmodule // mux7to1


/* 4-bit adder module */
module fourBitAdder (input [3:0] A, B, input c_in, 
							output [3:0] S, output c_out);

				wire [2:0] C; // carry-pin vector
				
				// check schematic for wiring
				fullAdder bit0 (.c_in(c_in), .a(A[0]), .b(B[0]), .s(S[0]), .c_out(C[0]));
				fullAdder bit1 (.c_in(C[0]), .a(A[1]), .b(B[1]), .s(S[1]), .c_out(C[1]));
				fullAdder bit2 (.c_in(C[1]), .a(A[2]), .b(B[2]), .s(S[2]), .c_out(C[2]));
				fullAdder bit3 (.c_in(C[2]), .a(A[3]), .b(B[3]), .s(S[3]), .c_out(c_out));

endmodule // fourBitAdder


/* full adder module */
module fullAdder (input c_in, a, b, output s, c_out);

				assign s = (a ^ b ^ c_in); // odd function for sum bit
				assign c_out = ((a & b) | (a & c_in) | (b & c_in)); // majority function for carry-out bit

endmodule // fullAdder


/* BCD to common-anode seven-segment display decoder */
module bcdDecoder (input [3:0] C, output [6:0] HEX);

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

endmodule // bcdDecoder