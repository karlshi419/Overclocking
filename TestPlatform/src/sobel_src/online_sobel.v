`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:03:33 02/10/2015 
// Design Name: 
// Module Name:    online_sobel 
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
module online_sobel(clk, nrst, enable, din_x, data_out);
parameter Stage = 8;
localparam WL = Stage * 2;

localparam WL_yout = 2*(Stage+4);

	input clk, nrst;
	input enable;
	input [WL-1:0] din_x;
	output [WL_yout-1:0] data_out;
	
	reg [WL-1:0] din_x_reg 		= 0;
	reg [WL_yout-1:0]  y_out_reg = 0;
	
	reg [WL-1:0] x_reg0 = 0;
	reg [WL-1:0] x_reg1 = 0;
	reg [WL-1:0] x_reg2 = 0;
	reg [WL-1:0] x_reg3 = 0;
	reg [WL-1:0] x_reg4 = 0;
	reg [WL-1:0] x_reg5 = 0;
	reg [WL-1:0] x_reg6 = 0;
	reg [WL-1:0] x_reg7 = 0;
	reg [WL-1:0] x_reg8 = 0;
	
	wire [WL-1:0] x2_n, x5_n, x6_n, x7_n, x8_n;
	assign x2_n = ~x_reg2;
	assign x5_n = ~x_reg5;
	assign x6_n = ~x_reg6;
	assign x7_n = ~x_reg7;
	assign x8_n = ~x_reg8;
	
	//---- Output signals of OAs ----//
	wire [WL+1:0] z_oa1, z_oa3, z_oa4, z_oa6;
	wire [WL+3:0] z_oa2, z_oa5;
	
	wire [WL+3:0] z_gx_temp, z_gy_temp;
	wire [WL+5:0] z_gx, z_gy;
	
	wire [WL+7:0] z_sum;
	
	//---- Connect Online Adders ----//
	online_adder #(Stage) 	OA1(.x(x_reg0),.y(x2_n), .cin(1'b0), .z(z_oa1));
	online_adder #(Stage+1) OA2(.x({x_reg3,2'b0}),.y({x5_n,2'b0}), .cin(1'b0), .z(z_oa2));
	online_adder #(Stage) 	OA3(.x(x_reg6),.y(x8_n), .cin(1'b0), .z(z_oa3));
	online_adder #(Stage) 	OA4(.x(x_reg0),.y(x6_n), .cin(1'b0), .z(z_oa4));
	online_adder #(Stage+1) OA5(.x({x_reg1,2'b0}),.y({x7_n,2'b0}), .cin(1'b0), .z(z_oa5));
	online_adder #(Stage) 	OA6(.x(x_reg2),.y(x8_n), .cin(1'b0), .z(z_oa6));
	
	online_adder #(Stage+1)	OA_gx_temp(.x(z_oa1),.y(z_oa3), .cin(1'b0), .z(z_gx_temp));
	online_adder #(Stage+1)	OA_gy_temp(.x(z_oa4),.y(z_oa6), .cin(1'b0), .z(z_gy_temp));
	
	online_adder #(Stage+2) OA_gx(.x(z_oa2),.y(z_gx_temp), .cin(1'b0), .z(z_gx));
	online_adder #(Stage+2) OA_gy(.x(z_oa5),.y(z_gy_temp), .cin(1'b0), .z(z_gy));
		
	online_adder #(Stage+3) OA_sum(.x(z_gx),.y(z_gy), .cin(1'b0), .z(z_sum));
	
	always @ (posedge clk) begin
		if(!nrst) begin
			din_x_reg	<= 0;
			y_out_reg	<= 0;
			{x_reg0,x_reg1,x_reg2,x_reg3,x_reg4,x_reg5,x_reg6,x_reg7,x_reg8}	<= 'b0;
		end
		else begin
			if(enable) begin
				y_out_reg	<= #1 z_sum;
				din_x_reg	<= #1 din_x;
				x_reg0		<= #1 din_x_reg;
				x_reg1		<= #1 x_reg0;
				x_reg2		<= #1 x_reg1;
				x_reg3		<= #1 x_reg2;
				x_reg4		<= #1 x_reg3;
				x_reg5		<= #1 x_reg4;	
				x_reg6		<= #1 x_reg5;
				x_reg7		<= #1 x_reg6;
				x_reg8		<= #1 x_reg7;				
			end
			else begin
				din_x_reg	<= 0;
				y_out_reg	<= 0;
				{x_reg0,x_reg1,x_reg2,x_reg3,x_reg4,x_reg5,x_reg6,x_reg7,x_reg8}	<= 'b0;
			end
		end
	end
	
	assign data_out = y_out_reg;

endmodule
