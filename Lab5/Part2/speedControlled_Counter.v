`timescale 1ns / 1ns // `timescale time_unit/time_precision

/* top-level entity for the speed controlled counter */
module lab5Part2 (input [2:0] SW, input CLOCK_50, output [9:0] LEDR, output [6:0] HEX0);

				assign LEDR[9:0] = 10'b0000000000; // all LEDs remain off
				wire [4:0] disp_Count;
						
				speedController S1 (.f_Select(SW[1:0]), .clock(CLOCK_50), 
												.reset(SW[2]), .countState(disp_Count));
				BCD_to_HEX_Decoder D1 (.C(disp_Count[3:0]), .HEX(HEX0));
						
endmodule // lab5Part2

/*  */
module speedController (input [1:0] f_Select, input clock, reset, 
								output [4:0] countState);

				wire [25:0] m_Cycles; // to connect max cycles.
				wire dwnClk_Enable; // downclocked, synchronous enable for counter
				
				speedSelect S1 (.sel(f_Select), .maxCycles(m_Cycles));
				rateDivider R1 (.maxCycles(m_Cycles), .clock(clock), .reset(reset), 
									.downClock(dwnClk_Enable));
				fourBit_Counter C1 (.clock(clock), .reset(reset), 
										.enable(dwnClk_Enable), .Q(countState));
				
endmodule // speedController

/**/
module speedSelect (input [1:0] sel, output reg [25:0] maxCycles);

				always @(*)
				begin
				
					case(sel)
						2'b00: maxCycles = 26'd1; // 50MHz
						2'b01: maxCycles = 26'd12;//500000; // 4Hz
						2'b10: maxCycles = 26'd25;//000000; // 2Hz
						2'b11: maxCycles = 26'd50;//000000; // 1Hz
						default: maxCycles = 26'd50000000; // dwef
					endcase
				
				end

endmodule // speedSelect

/* downclocks input 50 MHz clock for feeding into other modules */
module rateDivider(input [25:0] maxCycles, input clock, reset, output downClock);
				
				reg [25:0] cycleCount;
				
				always @(posedge clock) // triggered on edges of clock
				begin
				
					if (reset == 1'b0) // synchronous active -low
						cycleCount <= 26'd0;						
					else if (cycleCount == 26'd0) 
						cycleCount <= maxCycles; // reset counter to 50M
					else
						cycleCount <= cycleCount - 1'b1; // decrement state
						
				end
				
				assign downClock = (cycleCount == 26'd0) ? (1'b1):(1'b0);

endmodule // rateDivider

/* 4-bit counter to which accepts the downclocked enable */
module fourBit_Counter (input clock, reset, enable, output reg [4:0] Q);

				always @(posedge clock) // triggered on rising edge of clock
				begin
				
					if (reset == 1'd0) // synch reset active-low
						Q <= 5'd0;
					else if (Q == 5'd16) // max vvalll
						Q <= 5'd0;
					else if (enable == 1'd1) // increment on enable
						Q <= Q + 1;
					else
						Q <= Q;
						
				end

endmodule // fourBit_Counter

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