`timescale 1ns / 1ns // `timescale time_unit/time_precision


/* top-level entity for 2 to 1 multiplexer */
module mux2to1 (input [9:0] SW, output [9:0] LEDR);

					// check schematic for placement of wires
					wire W1, W2, W3;
					
					/*
					 * SW[0] is x, input bit #1
					 * SW[1] is y, input bit #2
					 * SW[9] is s, the select pin 
					 * and LEDR[0] is the output 
					 */
					 
					v7404 C1 (.pin1(SW[9]), .pin2(W1)); // NOT
					
					v7408 C2 (.pin1(W1), .pin2(SW[0]), .pin3(W2), .pin4(SW[9]),  
								.pin5(SW[1]), .pin6(W3)); // AND
								
					v7432 C3 (.pin1(W2), .pin2(W3), .pin3(LEDR[0])); // OR

endmodule // mux2to1


/* Quad 2-input AND chip */
module v7408 (input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13, 
				output pin3, pin6, pin8, pin11);
				
				assign pin3 = pin1 & pin2;
				assign pin6 = pin4 & pin5;
				assign pin8 = pin9 & pin10;
				assign pin11 = pin12 & pin13;
				
endmodule // v7408


/* Quad 2-input OR chip */
module v7432 (input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13, 
				output pin3, pin6, pin8, pin11);

				assign pin3 = pin1 | pin2;
				assign pin6 = pin4 | pin5;
				assign pin8 = pin9 | pin10;
				assign pin11 = pin12 | pin13;
				
endmodule // v7432


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