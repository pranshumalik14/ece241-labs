`timescale 1ns / 1ns // `timescale time_unit/time_precision

/* top-level entity for polynomial calculator */
module fpga_top (input [9:0] SW, input [3:0] KEY, input CLOCK_50, 
					output [9:0] LEDR, output [6:0] HEX0, HEX1);

				wire resetn;
				wire go;
				wire [7:0] data_result;
				
				/* 
				 * Sw[7:0] is data_in
				 * KEY[0] synchronous reset when pressed
				 * KEY[1] is go signal
				 * LEDR displays result
				 * HEX0 and HEX1 also display result
				*/
				
				assign go = ~KEY[1];
				assign resetn = KEY[0];
				assign LEDR[7:0] = data_result;

				poly_calc u0 (.clk(CLOCK_50), .resetn(resetn), .go(go), .data_in(SW[7:0]),
							.data_result(data_result));
				hex_decoder H0 (.hex_digit(data_result[3:0]), .segments(HEX0));
				hex_decoder H1 (.hex_digit(data_result[7:4]), .segments(HEX1));

endmodule // fpga_top

/* polynomial calculator */
module poly_calc (input clk, resetn, go, input [7:0] data_in, 
						output [7:0] data_result);

				// wires to connect datapath and control
				wire ld_a, ld_b, ld_c, ld_x, ld_r;
				wire ld_alu_out;
				wire [1:0]  alu_select_a, alu_select_b;
				wire alu_op;

				control C0 (.clk(clk), .resetn(resetn), .go(go), .ld_alu_out(ld_alu_out), 
								.ld_x(ld_x), .ld_a(ld_a), .ld_b(ld_b), .ld_c(ld_c), 
								.ld_r(ld_r), .alu_select_a(alu_select_a), 
								.alu_select_b(alu_select_b), .alu_op(alu_op));
								
				datapath D0 (.clk(clk), .resetn(resetn), .ld_alu_out(ld_alu_out), 
								.ld_x(ld_x), .ld_a(ld_a), .ld_b(ld_b), .ld_c(ld_c), 
								.ld_r(ld_r), .alu_select_a(alu_select_a), 
								.alu_select_b(alu_select_b), .alu_op(alu_op),
								.data_in(data_in), .data_result(data_result));
                
endmodule // poly_calc
                
/* controls registers and state transition */
module control (input clk, resetn, go, output reg  ld_a, ld_b, ld_c, ld_x, 
					ld_r, ld_alu_out, output reg [1:0]  alu_select_a, alu_select_b,
					output reg alu_op);

				reg [5:0] current_state, next_state; 
				localparam  S_LOAD_A 		 = 5'd0,
								S_LOAD_A_WAIT   = 5'd1,
								S_LOAD_B        = 5'd2,
								S_LOAD_B_WAIT   = 5'd3,
								S_LOAD_C        = 5'd4,
								S_LOAD_C_WAIT   = 5'd5,
								S_LOAD_X        = 5'd6,
								S_LOAD_X_WAIT   = 5'd7,
								S_CYCLE_0       = 5'd8,
								S_CYCLE_1       = 5'd9,
								S_CYCLE_2       = 5'd10,
								S_CYCLE_3       = 5'd11;
				// state table
				always @(*)
				begin

				case (current_state)
					// loop in current state until value is input
					S_LOAD_A: next_state = go ? S_LOAD_A_WAIT : S_LOAD_A;
					// loop in current state until go signal goes low
					S_LOAD_A_WAIT: next_state = go ? S_LOAD_A_WAIT : S_LOAD_B;
					// loop in current state until value is input
					S_LOAD_B: next_state = go ? S_LOAD_B_WAIT : S_LOAD_B; 
					// loop in current state until go signal goes low
					S_LOAD_B_WAIT: next_state = go ? S_LOAD_B_WAIT : S_LOAD_C;
					// loop in current state until value is input
					S_LOAD_C: next_state = go ? S_LOAD_C_WAIT : S_LOAD_C; 
					// loop in current state until go signal goes low
					S_LOAD_C_WAIT: next_state = go ? S_LOAD_C_WAIT : S_LOAD_X;
					// loop in current state until value is input
					S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X; 
					// loop in current state until go signal goes low
					S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_CYCLE_0; 
					S_CYCLE_0: next_state = S_CYCLE_1;
					S_CYCLE_1: next_state = S_CYCLE_2;
					S_CYCLE_2: next_state = S_CYCLE_3;
					// start over after
					S_CYCLE_3: next_state = S_LOAD_A; 
					default: next_state = S_LOAD_A;
				endcase

				end // state_table
   

				// output logic for datapath control signals
				always @(*)
				begin
				// all signals are 0 by default, to avoid latches.

					ld_alu_out = 1'b0;
					ld_a = 1'b0;
					ld_b = 1'b0;
					ld_c = 1'b0;
					ld_x = 1'b0;
					ld_r = 1'b0;
					alu_select_a = 2'b0;
					alu_select_b = 2'b0;
					alu_op       = 1'b0;

					case (current_state)
						S_LOAD_A: begin
										ld_a = 1'b1;
									 end
						S_LOAD_B: begin
										ld_b = 1'b1;
									 end
						S_LOAD_C: begin
										ld_c = 1'b1;
									 end
						S_LOAD_X: begin
										ld_x = 1'b1;
									 end
						S_CYCLE_0: begin // do B <- B * x 
										ld_alu_out = 1'b1; ld_b = 1'b1; // store result back into B
										alu_select_a = 2'd1; // select register B
										alu_select_b = 2'd3; // also select register x
										alu_op = 1'b1; // do multiply operation
									  end
						S_CYCLE_1: begin // do A <- A + B
										ld_alu_out = 1'b1; ld_a = 1'b1; // store result back into A
										alu_select_a = 2'd0; // select register A
										alu_select_b = 2'd1; // also select register B
										alu_op = 1'b0; // do addition operation
									  end
						S_CYCLE_2: begin // do A <- A * x
										ld_alu_out = 1'b1; ld_a = 1'b1; // store result back into A
										alu_select_a = 2'd0; // select register A
										alu_select_b = 2'd3; // also select register x
										alu_op = 1'b1; // do multiply operation
									  end
						S_CYCLE_3: begin // do A + C
										ld_r = 1'b1; // store result in result register
										alu_select_a = 2'd0; // select register A
										alu_select_b = 2'd2; // select register C
										alu_op = 1'b0; // do addition operation
									  end
						// no default needed; all of our outputs were assigned a value
					endcase		 
				
				end // enable_signals

				// current_state registers
				always @(posedge clk)
				begin
					if(!resetn)
						current_state <= S_LOAD_A;
					else
						current_state <= next_state;
				end // state_FFS
				
endmodule // control

module datapath (input clk, resetn, ld_x, ld_a, ld_b, ld_c,
					ld_r, alu_op, ld_alu_out, input [7:0] data_in, 
					input [1:0] alu_select_a, alu_select_b,
					output reg [7:0] data_result);
    
				reg [7:0] a, b, c, x; // input registers
				reg [7:0] alu_out; // output of the alu
				reg [7:0] alu_a, alu_b; // alu input muxes

				// registers a, b, c, x with respective input logic
				always@(posedge clk) begin
				  
				  if(!resetn) 
				  begin
						a <= 8'b0; 
						b <= 8'b0; 
						c <= 8'b0; 
						x <= 8'b0; 
				  end
				  
				  else 
				  begin
						// load alu_out if load_alu_out signal is high, otherwise load from data_in
						if(ld_a)
							 a <= ld_alu_out ? alu_out : data_in;
						// load alu_out if load_alu_out signal is high, otherwise load from data_in
						if(ld_b)
							 b <= ld_alu_out ? alu_out : data_in;
						if(ld_x)
							 x <= data_in;
						if(ld_c)
							 c <= data_in;
				  end
				end

				// output result register
				always@(posedge clk) begin
				  if(!resetn) begin
						data_result <= 8'b0; 
				  end
				  else 
						if(ld_r)
							 data_result <= alu_out;
				end

				// the ALU input multiplexers
				always @(*)
				begin
				  case (alu_select_a)
						2'd0:
							 alu_a = a;
						2'd1:
							 alu_a = b;
						2'd2:
							 alu_a = c;
						2'd3:
							 alu_a = x;
						default: alu_a = 8'b0;
				  endcase

				  case (alu_select_b)
						2'd0:
							 alu_b = a;
						2'd1:
							 alu_b = b;
						2'd2:
							 alu_b = c;
						2'd3:
							 alu_b = x;
						default: alu_b = 8'b0;
				  endcase
				end

				// ALU 
				always @(*)
				begin : ALU
				  case (alu_op)
						// performs addition
						0: begin
								 alu_out = alu_a + alu_b; 
							end
						// performs multiplication
						1: begin
								 alu_out = alu_a * alu_b;
							end
						default: alu_out = 8'b0;
				  endcase
				end
    
endmodule // datapath

/* bcd to hex for seven-segment display */
module hex_decoder(input [3:0] hex_digit, output reg [6:0] segments);
    
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