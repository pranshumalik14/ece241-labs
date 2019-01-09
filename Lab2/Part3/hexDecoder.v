`timescale 1ns / 1ns // `timescale time_unit/time_precision


/* top level entity for binary coded decimal (BCD) to hex display */
module hexDisplay (input [3:0] SW, output [6:0] HEX0);

				// SW is the input bus and HEX0 is the output bus
				bcdDecoder C1 (.C(SW), .H(HEX0));

endmodule // hexDisplay


/* BCD to seven-segment display decoder */
module bcdDecoder (input [3: 0] C, output [6:0] H);

				// maxterms for every segment LED
				assign H[0] = (C[3]|C[2]|C[1]|!C[0]) & (C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|!C[0]);
								
				assign H[1] = (C[3]|!C[2]|C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|C[0]) & 
								(!C[3]|C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|!C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]);
								
				assign H[2] = (C[3]|C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|!C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]);
								
				assign H[3] = (C[3]|C[2]|C[1]|!C[0]) & (C[3]|!C[2]|C[1]|C[0]) & 
								(C[3]|!C[2]|!C[1]|!C[0]) & (!C[3]|C[2]|C[1]|!C[0]) & 
								(!C[3]|C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]);
								
				assign H[4] = (C[3]|C[2]|C[1]|!C[0]) & (C[3]|C[2]|!C[1]|!C[0]) & 
								(C[3]|!C[2]|C[1]|C[0]) & (C[3]|!C[2]|C[1]|C[0]) &
								(C[3]|!C[2]|C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|!C[0]) &
								(!C[3]|C[2]|C[1]|!C[0]);
								
				assign H[5] = (C[3]|C[2]|C[1]|!C[0]) & (C[3]|C[2]|!C[1]|C[0]) & 
								(C[3]|C[2]|!C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|!C[0]) & 
								(!C[3]|!C[2]|C[1]|!C[0]);
								
				assign H[6] = (C[3]|C[2]|C[1]|C[0]) & (C[3]|C[2]|C[1]|!C[0]) & 
								(C[3]|!C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|C[0]);

endmodule // bcdDecoder