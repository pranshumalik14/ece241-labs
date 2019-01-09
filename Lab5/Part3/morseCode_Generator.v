`timescale 1ns / 1ns // `timescale time_unit/time_precision

/* top-level entity for the morse code generator */
module lab5Part3 (input [2:0] SW, input [1:0] KEY, input CLOCK_50, output [9:0] LEDR);

				assign LEDR[9:1] = 9'd0;
				
				 morseCode_Generator M1 (.alphabet(SW[1:0]), .reset(KEY[0]), .clock(CLOCK_50), 
												.msg_Send(KEY[1]), .morseQueue_Top(LEDR[0]));
				 
endmodule // lab5Part3

/*  */
module morseCode_Generator (input [2:0] alphabet, input reset, clock, msg_Send,  
									output morseQueue_Top);

				wire [12:0] morse_Binary;
				wire dwnClk_Enable;
				wire [12:0] queueMorse;
				assign morseQueue_Top = queueMorse[0];
				morseCode_Mux M1 (.sel(alphabet), .morseCode(morse_Binary));
				rateDivider R1 (.clock(clock), .reset(reset), .downClock(dwnClk_Enable));
				universal_ShiftReg U1 (.DATA_IN(morse_Binary), .ParallelLoad_n(msg_Send), 
										.clock(dwnClk_Enable), .reset(reset), .Q_out(queueMorse));

endmodule // morseCode_Generator

/* binary-coded morse selection */
module morseCode_Mux (input sel, output reg [12:0] morseCode);

				always @(*)
				begin
				
					case (sel)						
						3'b000: morseCode = 13'b1010100000000; // letter S
						3'b001: morseCode = 13'b1110000000000; // letter T
						3'b010: morseCode = 13'b1010111000000; // letter U
						3'b011: morseCode = 13'b1010101110000; // letter V
						3'b100: morseCode = 13'b1011101110000; // letter W
						3'b101: morseCode = 13'b1110101011100; // letter X
						3'b110: morseCode = 13'b1110101110111; // letter Y
						3'b001: morseCode = 13'b1110111010100; // letter Z
					endcase 
				
				end

endmodule // morseCode_Mux

/* downclocks input 50 MHz clock to 2Hz */
module rateDivider(input clock, reset, output downClock);
				
				reg [25:0] cycleCount;
				
				always @(posedge clock) // triggered on edges of clock
				begin
				
					if (reset == 1'b0) // synchronous active -low
						cycleCount <= 26'd0;						
					else if (cycleCount == 26'd0) 
						cycleCount <= 26'd25000000; // reset counter to 25M
					else
						cycleCount <= cycleCount - 1'b1; // decrement state
						
				end
				
				assign downClock = (cycleCount == 26'd0) ? (1'b1):(1'b0);

endmodule // rateDivider

/* universal shift register, being used to store (reversed) morse code */
module universal_ShiftReg (input [12:0] DATA_IN, ParallelLoad_n, clock, reset, 
									output [12:0] Q_out);
				
				wire [12:0] Q; // carries the output of the flip-flops and subsequent connections
				assign Q_out = Q; // assigning outputs of flip-flops to the register output
				
				// instantiation of all 13 flip-flops for the register
				flipFlop F12 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[0]), .right(Q[11]), .data(DATA_IN[0]), 
								.LSRight(1'b1), .Q(Q[12])); // flip-flop for bit 12
				
				flipFlop F11 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[12]), .right(Q[10]), .data(DATA_IN[1]), 
								.LSRight(1'b0), .Q(Q[11])); // flip-flop for bit 11
				
				flipFlop F10 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[11]), .right(Q[9]), .data(DATA_IN[2]), 
								.LSRight(1'b0), .Q(Q[10])); // flip-flop for bit 10
				
				flipFlop F9 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[10]), .right(Q[8]), .data(DATA_IN[3]), 
								.LSRight(1'b0), .Q(Q[9])); // flip-flop for bit 9
				
				flipFlop F8 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[9]), .right(Q[7]), .data(DATA_IN[4]), 
								.LSRight(1'b0), .Q(Q[8])); // flip-flop for bit 8
				
				flipFlop F7 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[8]), .right(Q[6]), .data(DATA_IN[5]), 
								.LSRight(1'b0), .Q(Q[7])); // flip-flop for bit 7
								
				flipFlop F6 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[7]), .right(Q[5]), .data(DATA_IN[6]), 
								.LSRight(1'b0), .Q(Q[6])); // flip-flop for bit 6
								
				flipFlop F5 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[6]), .right(Q[4]), .data(DATA_IN[7]), 
								.LSRight(1'b0), .Q(Q[5])); // flip-flop for bit 5
								
				flipFlop F4 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[5]), .right(Q[3]), .data(DATA_IN[8]), 
								.LSRight(1'b0), .Q(Q[4])); // flip-flop for bit 4
								
				flipFlop F3 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[4]), .right(Q[2]), .data(DATA_IN[9]), 
								.LSRight(1'b0), .Q(Q[3])); // flip-flop for bit 3
								
				flipFlop F2 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[3]), .right(Q[1]), .data(DATA_IN[10]), 
								.LSRight(1'b0), .Q(Q[2])); // flip-flop for bit 2
								
				flipFlop F1 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[2]), .right(Q[0]), .data(DATA_IN[11]), 
								.LSRight(1'b0), .Q(Q[1])); // flip-flop for bit 1
								
				flipFlop F0 (.clock(clock), .reset(reset), .load_n(ParallelLoad_n), 
								.loadLeft(1'b1), .left(Q[1]), .right(Q[12]), .data(DATA_IN[12]), 
								.LSRight(1'b0), .Q(Q[0])); // flip-flop for bit 0 (LSB)

endmodule // universal_ShiftReg

/* flip-flop with multiplexers to select input */
module flipFlop (input clock, reset, load_n, data, loadLeft, right, left, 
					LSRight, output reg Q);

				wire R, D;
				
				/*
				 * loadleft = 1 will select left, and right otherwise
				 * load_n = 0 will select data, and output of rotation select otherwise
				*/
				
				mux2to1 M1 (.x(right), .y(left), .sel(loadLeft), .f(R)); // left-right rotate option select
				mux2to1 M2 (.x(data), .y(R), .sel(load_n), .f(D)); // parallel load and rotate select
				
				// triggered on rising edge of the clock signal and falling edge of clear
				always @(posedge clock, negedge reset)
				begin
				
					if (reset == 1'b0) // active-low, asynchronous reset to 0
						Q <= 1'b0;
					else if (LSRight == 1'b1 && loadLeft == 1'b1) // override D during logical shift right
						Q <= 1'b0;
					else
						Q <= D; // if reset and LSRight are 0, flip-flop tracks D
				
				end

endmodule // flipFlop

/* 2 to 1 multiplexer */
module mux2to1(input x, y, sel, output f);

				assign f = sel ? y : x; // f = y when sel = 1, x otherwise

endmodule // mux2to1