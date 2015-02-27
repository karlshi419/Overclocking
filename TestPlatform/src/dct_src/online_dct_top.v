`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:13:11 02/12/2015 
// Design Name: 
// Module Name:    online_dct_top 
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
module online_dct_top(clk,nrst,enable,din_x, data_out);
parameter Stage = 8;
localparam WL = Stage * 2;

localparam WL_ccm_3 		= 2*(Stage+2);
localparam WL_ccm_7		= 2*(Stage+3);

localparam stage_oa		= Stage+3;
localparam stage_oa_out	= Stage+4;

localparam WL_oa			= 2*stage_oa;
localparam WL_oa_out		= 2*stage_oa_out;

localparam WL_yout		= 2*(Stage+5);

	input clk, nrst;
	input enable;
	input [WL-1:0] din_x;
	output [WL_yout-1:0] data_out;
	
	//reg [WL-1:0] din_x_reg = 0;
	reg [WL_yout-1:0]	data_out_reg;
	
	reg [WL-1:0] x_reg1=0;
	reg [WL-1:0] x_reg2=0;
	reg [WL-1:0] x_reg3=0;
	reg [WL-1:0] x_reg4=0;
	
	//---- Output signals of CCMs ----//
	wire [WL_ccm_3-1:0] y_ccm1, y_ccm4;
	wire [WL_ccm_7-1:0] y_ccm2, y_ccm3;
	
	//---- Output signals of OAs ----//
	wire [WL_oa+1:0] z_oa3;
	wire [WL_oa+1:0] z_oa2,z_oa2_n;
	wire [WL_oa_out+1:0] z_oa1;
	
	assign z_oa2_n = ~z_oa2;
	
	//---- Connect All CCMs ----//
	online_ccm_3	#Stage	ccm1(.x(x_reg1), .y(y_ccm1));
	online_ccm_7	#Stage	ccm2(.x(x_reg2), .y(y_ccm2));
	online_ccm_7	#Stage	ccm3(.x(x_reg3), .y(y_ccm3));
	online_ccm_3	#Stage	ccm4(.x(x_reg4), .y(y_ccm4));
	
	//---- Connect All Online Adders ----//
	online_adder #(stage_oa) 		OA3(.x(y_ccm2), .y({2'b0,y_ccm1}), .cin(1'b0), .z(z_oa3));
	online_adder #(stage_oa) 		OA2(.x(y_ccm3), .y({2'b0,y_ccm4}), .cin(1'b0), .z(z_oa2));
	online_adder #(stage_oa_out) 	OA1(.x(z_oa3), .y(z_oa2_n), .cin(1'b0), .z(z_oa1));
	
	always @(posedge clk) begin
		if(!nrst) begin
			data_out_reg <= 0;
			{x_reg1,x_reg2,x_reg3,x_reg4} <= 0;
		end
		else begin
			if(enable) begin
				data_out_reg <= #1 z_oa1;
				x_reg1	<= #1 din_x;
				x_reg2	<= #1 x_reg1;
				x_reg3	<= #1 x_reg2;
				x_reg4	<= #1 x_reg3;
			end
			else begin
				data_out_reg <= 0;
				{x_reg1,x_reg2,x_reg3,x_reg4} <= 0;
			end
		end
	end
	
	assign data_out = data_out_reg;
 
endmodule
