`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:35:13 01/30/2015 
// Design Name: 
// Module Name:    online_fir 
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
module online_fir(clk, nrst, enable, din_x, data_out);
parameter Stage = 8;
localparam WL = Stage * 2;

localparam WL_ccm_m2 	= 2*(Stage+1);
localparam WL_ccm_18 	= 2*(Stage+5);
localparam WL_ccm_129	= 2*(Stage+8);

localparam stage_oa5 = (Stage+5);
localparam stage_oa4 = (Stage+8);
localparam stage_oa3 = (Stage+9);
localparam stage_oa2 = (Stage+10);
localparam stage_oa1 = (Stage+11);
	
localparam WL_oa5	= 2*stage_oa5;
localparam WL_oa4 = 2*stage_oa4;
localparam WL_oa3 = 2*stage_oa3;
localparam WL_oa2 = 2*stage_oa2;
localparam WL_oa1 = 2*stage_oa1;

localparam WL_yout = 2*(Stage+12);
	
	input clk, nrst;
	input enable;
	input [WL-1:0]	din_x;
	output [WL_yout-1:0] data_out;
	
	reg [WL-1:0] din_x_reg 		= 0;
	reg [WL_yout-1:0]  y_out_reg = 0;
	
	reg [WL-1:0] x_reg1 = 0;
	reg [WL-1:0] x_reg2 = 0;
	reg [WL-1:0] x_reg3 = 0;
	reg [WL-1:0] x_reg4 = 0;
	reg [WL-1:0] x_reg5 = 0;
	
	//---- Output signals of CCMs ----//
	wire [WL_ccm_m2-1:0] y_ccm1, y_ccm6;
	wire [WL_ccm_18-1:0] y_ccm2, y_ccm5;
	wire [WL_ccm_129-1:0] y_ccm3, y_ccm4;
	
	//---- Output signals of OAs ----//
	wire [WL_oa5+1:0] z_oa5;
	wire [WL_oa4+1:0] z_oa4;
	wire [WL_oa3+1:0] z_oa3;
	wire [WL_oa2+1:0] z_oa2;
	wire [WL_oa1+1:0] z_oa1;

	//---- Connect All CCMs ----//
	online_ccm_m2	#Stage	ccm1(.x(din_x_reg), .y(y_ccm1));
	online_ccm_18	#Stage	ccm2(.x(x_reg1), .y(y_ccm2));
	online_ccm_129	#Stage	ccm3(.x(x_reg2), .y(y_ccm3));
	
	online_ccm_129	#Stage	ccm4(.x(x_reg3), .y(y_ccm4));
	online_ccm_18	#Stage	ccm5(.x(x_reg4), .y(y_ccm5));
	online_ccm_m2	#Stage	ccm6(.x(x_reg5), .y(y_ccm6));
	
	//---- Connect All online adders ----//
	online_adder #(stage_oa5) OA5(.x(y_ccm5),.y({8'b0,y_ccm6}),	.cin(1'b0), .z(z_oa5));
	online_adder #(stage_oa4) OA4(.x(y_ccm4),.y({4'b0,z_oa5}), 	.cin(1'b0), .z(z_oa4));
	online_adder #(stage_oa3) OA3(.x({2'b0,y_ccm3}),.y(z_oa4), 	.cin(1'b0), .z(z_oa3));
	online_adder #(stage_oa2) OA2(.x({10'b0,y_ccm2}),.y(z_oa3), .cin(1'b0), .z(z_oa2));
	online_adder #(stage_oa1) OA1(.x({20'b0,y_ccm1}),.y(z_oa2), .cin(1'b0), .z(z_oa1));
	
	always @ (posedge clk) begin
		if(!nrst) begin
			din_x_reg	<= 0;
			y_out_reg	<= 0;
			{x_reg1,x_reg2,x_reg3,x_reg4,x_reg5}	<= 'b0;
		end
		else begin
			if(enable) begin
				y_out_reg	<= #1 z_oa1;
				din_x_reg	<= #1 din_x;
				x_reg1		<= #1 din_x_reg;
				x_reg2		<= #1 x_reg1;
				x_reg3		<= #1 x_reg2;
				x_reg4		<= #1 x_reg3;
				x_reg5		<= #1 x_reg4;		
			end
			else begin
				din_x_reg	<= 0;
				y_out_reg	<= 0;
				{x_reg1,x_reg2,x_reg3,x_reg4,x_reg5}	<= 'b0;
			end
		end
	end
	
	assign data_out = y_out_reg;
	
endmodule
