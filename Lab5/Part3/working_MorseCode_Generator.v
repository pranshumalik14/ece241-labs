`timescale 1ns / 1ns // `timescale time_unit/time_precision

module flipflop(D, clk, Reset_b, Q);
	input D;
	input clk, Reset_b;
	output reg Q;
	
	always @(posedge clk, negedge Reset_b) // triggered every time clock rises
	begin
		if (Reset_b == 1'b0) // when Reset b is 1 (note this is tested on every rising clock edge)
			Q <= 0; // q is set to 0. Note that the assignment uses <=
		else // when Reset b is not 1
			Q <= D; // value of d passes through to output q
	end	
endmodule

module subCircuit(input ParallelLoadn, DataIn, clock, reset, rightIn, output Q);
	
	wire w_toDFF;
	
	mux2to1 M1(.x(DataIn), .y(rightIn), .s(ParallelLoadn), .m(w_toDFF));
	
	flipflop f1(.D(w_toDFF), .clk(clock), .Reset_b(reset), .Q(Q));

endmodule 

module charSelect(sel,out);
	input [2:0] sel;
	output reg [13:0] out;
	
	always @(*)
		begin
			case(sel[2:0])
				0: out = 14'b10101000000000;
				1: out = 14'b11100000000000;
				2: out = 14'b10101110000000;
				3: out = 14'b10101110000000;
				4: out = 14'b10111011100000;
				5: out = 14'b11101010111000;
				6: out = 14'b11101011101110;
				7: out = 14'b11101110101000;
				default: out = 14'b00000000000000;
			endcase
		end
endmodule 

module mux2to1(input x, y, s, output m);
	
	assign m= (~s&x)|(s&y);
	
endmodule //2 to 1 mux

module rateDivider(d,q,clock,clear_b,Enable);
	input clock,clear_b, Enable;
	output reg [25:0] q; // declare q
	input [25:0] d; // declare d
	
	always @(posedge clock) // triggered every time clock rises
		begin
			if (clear_b == 1'b0) // when Clear b is 0
				q <= 0; // q is set to 0
			else if (q == 0) // when q is the maximum value for the counter
				q <= d; // q reset to d
			else if (Enable == 1'b1) // decrement q only when Enable is 1
				q <= q - 1; // decrement q
		end
		
endmodule

module enablePulse(input [25:0] in, output reg out);
	always @(*)
		begin
			if(in == 1)
				out = 1;
			else 
				out = 0;
		end
endmodule

module shiftReg(dIn, load, clock, reset, out);
	wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13;
	input [13:0] dIn;
	input load, clock, reset;
	output out;

	subCircuit s0(load,dIn[13],clock,reset, w1, w0);
	subCircuit s1(load,dIn[12],clock,reset, w2, w1);
	subCircuit s2(load,dIn[11],clock,reset, w3, w2);
	subCircuit s3(load,dIn[10],clock,reset, w4, w3);
	subCircuit s4(load,dIn[9],clock,reset, w5, w4);
	subCircuit s5(load,dIn[8],clock,reset, w6, w5);
	subCircuit s6(load,dIn[7],clock,reset, w7, w6);
	subCircuit s7(load,dIn[6],clock,reset, w8, w7);
	subCircuit s8(load,dIn[5],clock,reset, w9, w8);
	subCircuit s9(load,dIn[4],clock,reset, w10, w9);
	subCircuit s10(load,dIn[3],clock,reset, w11, w10);
	subCircuit s11(load,dIn[2],clock,reset, w12, w11);
	subCircuit s12(load,dIn[1],clock,reset, w13, w12);
	subCircuit s13(load,dIn[0],clock,reset, 1'b0, w13);
	
	assign out = w0;
endmodule 


module Lab5Part3(SW,KEY,LEDR,CLOCK_50);
	input [2:0] SW;
	input [2:0] KEY;
	output [9:0] LEDR;
	input CLOCK_50;
	
	assign LEDR[9:1] = 9'd0;
	
	forSimulation c0(.selectLines(SW[2:0]), .clck(CLOCK_50),
								.reset(KEY[0]), .Parallel_Load(KEY[1]), .LEDR_out(LEDR[0]));
	
endmodule

module forSimulation ( selectLines, clck, reset, Parallel_Load, LEDR_out);

	input [2:0] selectLines;
	input clck, reset, Parallel_Load;
	output LEDR_out;
	
	wire [25:0] w0;
	wire w1;
	wire [13:0] w2;
			
	rateDivider r1(.d(25000000), .q(w0), .clock(clck), .clear_b(reset), .Enable(1'b1));
	
	enablePulse p1(w0,w1);
	
	charSelect m1(.sel(selectLines), .out(w2));
	
	shiftReg s1(.dIn(w2), .load(Parallel_Load), .clock(w1), .reset(reset), .out(LEDR_out));				
endmodule
