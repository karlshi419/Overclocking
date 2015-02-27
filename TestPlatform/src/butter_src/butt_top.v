`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:16:14 02/11/2015 
// Design Name: 
// Module Name:    butt_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module butt_top(clk,nrst,enable,din_x, data_out);
parameter Stage = 8;
localparam WL = Stage*2;

localparam WL_yout_pole = 2*(Stage+13);
localparam WL_yout_zero = 2*(Stage+14);

localparam WL_yout_oa	= 2*(Stage+15);

	input clk, nrst;
	input enable;
	input [WL-1:0] din_x;
	output [WL-1:0] data_out;
	
	reg [WL-1:0] data_out_reg;
	wire [WL-1:0] temp_dout;
	
	wire [WL_yout_pole-1:0] yout_pole;
	wire [WL_yout_zero-1:0] yout_zero;
	wire [WL_yout_zero-1:0] yout_pole_n;
	
	wire [WL_yout_oa-1:0] oa_sum;
	
	assign yout_pole_n[WL_yout_zero-1:WL_yout_pole] = 'b0;
	assign yout_pole_n[WL_yout_pole-1:0] 				= ~yout_pole;
	
	online_butt_zero #(Stage) butt_zero(.clk(clk), .nrst(nrst), .enable(enable), .din_x(din_x), .data_out(yout_zero));
	online_butt_pole #(Stage) butt_pole(.clk(clk), .nrst(nrst), .enable(enable), .din_x(data_out_reg), .data_out(yout_pole));
	
	online_adder #(Stage+14) butt_top_OA(.x(yout_zero),.y(yout_pole_n),.cin(1'b0),.z(oa_sum));
	
	// y=y/128
	assign temp_dout = oa_sum[WL+13:14];
	
	always @(posedge clk) begin
		if(!nrst) begin
			data_out_reg <= 0;
		end
		else begin
			if(enable) begin
				data_out_reg <= #1 temp_dout;
			end
			else begin
				data_out_reg <= 0;
			end
		end
	end
	
	assign data_out = data_out_reg;

endmodule
