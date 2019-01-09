`timescale 1ns / 1ns // `timescale time_unit/time_precision


/* top-level entity for v7404 chip logic test */
module testNOT (input [9:0] SW, output [9:0] LEDR);

				// SW[0] is the input and LEDR[0] is the output
				v7404 C1 (.pin1(SW[0]), .pin2(LEDR[0]));

endmodule // testNOT


/* Hex 2-input NOT chip */
module v7404 (input pin1, pin3, pin5, pin9, pin11, pin13, 
				output pin2, pin4, pin6, pin8, pin10, pin12);

				assign pin2 = !pin1;
				assign pin4 = !pin3;
				assign pin6 = !pin5;
				assign pin8 = !pin9;
				assign pin10 = !pin11;
				assign pin12 = !pin13;
				
endmodule // v7404