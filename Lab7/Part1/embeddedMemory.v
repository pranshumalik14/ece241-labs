`timescale 1ns / 1ns // `timescale time_unit/time_precision

/* top-level entity for 32 x 4 embedded memory */
module embedded_Memory (input [9:0] SW, input [0:0] KEY, output [6:0] HEX0, HEX2, HEX4, 
								HEX5, output [9:0] LEDR);

				assign LEDR[9:0] = 10'd0; // all LEDs on the board should be off
				
				/*
				 * KEY[0] is the clock
				 * SW[3:0] is the dataIn
				 * HEX2 displays dataIn
				 * SW[8:4] is the address
				 * HEX4 and HEX5 display address
				 * HEX0 displays dataOut
				 * SW[9] is writeEnable
				*/
				
				wire clock, writeEn;
				wire [3:0] dataIn, dataOut;
				wire [4:0] address;
				
				assign clock = KEY[0];
				assign writeEn = SW[9];
				assign dataIn = SW[3:0];
				assign address = SW[8:4];
				
				hex_decoder D1 (.hex_digit(dataIn), .segments(HEX2));
				hex_decoder D2 (.hex_digit(dataOut), .segments(HEX0));
				hex_decoder D3 (.hex_digit(address[3:0]), .segments(HEX4));
				hex_decoder D4 (.hex_digit({3'd0, address[4]}), .segments(HEX5));
				
				ram32x4 M1 (.address(address), .clock(clock), .data(dataIn), .wren(writeEn), .q(dataOut));

endmodule // embedded_Memory

/* bcd to hex for seven-segment display */
module hex_decoder (input [3:0] hex_digit, output reg [6:0] segments);
    
				always @(*)
				begin
				
					case (hex_digit)
						4'h0: segments = 7'b100_0000;
						4'h1: segments = 7'b111_1001;
						4'h2: segments = 7'b010_0100;
						4'h3: segments = 7'b011_0000;
						4'h4: segments = 7'b001_1001;
						4'h5: segments = 7'b001_0010;
						4'h6: segments = 7'b000_0010;
						4'h7: segments = 7'b111_1000;
						4'h8: segments = 7'b000_0000;
						4'h9: segments = 7'b001_1000;
						4'hA: segments = 7'b000_1000;
						4'hB: segments = 7'b000_0011;
						4'hC: segments = 7'b100_0110;
						4'hD: segments = 7'b010_0001;
						4'hE: segments = 7'b000_0110;
						4'hF: segments = 7'b000_1110;   
						default: segments = 7'h7f;
					endcase
				
				end
		  
endmodule // hex_decoder