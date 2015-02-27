`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:30 02/10/2015 
// Design Name: 
// Module Name:    online_iir_zero 
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
module online_iir_zero(clk, nrst, enable, din_x, data_out);
parameter Stage = 8;

localparam WL = Stage * 2;

localparam WL_ccm_2 	= 2*(Stage+1);
localparam WL_ccm_14	= 2*(Stage+5);
localparam WL_ccm_44	= 2*(Stage+6);
localparam WL_ccm_74	= 2*(Stage+7);

localparam stage_zero_oa1 = (Stage+11);
localparam stage_zero_oa2 = (Stage+10);
localparam stage_zero_oa3 = (Stage+9);
localparam stage_zero_oa4 = (Stage+8);
localparam stage_zero_oa5 = (Stage+7);
localparam stage_zero_oa6 = (Stage+6);
localparam stage_zero_oa7 = (Stage+5);

localparam WL_oa7	= 2*stage_zero_oa7;
localparam WL_oa6 = 2*stage_zero_oa6;
localparam WL_oa5	= 2*stage_zero_oa5;
localparam WL_oa4 = 2*stage_zero_oa4;
localparam WL_oa3 = 2*stage_zero_oa3;
localparam WL_oa2 = 2*stage_zero_oa2;
localparam WL_oa1 = 2*stage_zero_oa1;

localparam WL_yout = 2*(Stage+12);

	input clk, nrst;
	input enable;
	input [WL-1:0]	din_x;
	output [WL_yout-1:0] data_out;
	
	reg [WL-1:0] din_x_reg 		= 0;
	//reg [WL_yout-1:0]  y_out_reg = 0;
	
	reg [WL-1:0] zero_x_reg1 = 0;
	reg [WL-1:0] zero_x_reg2 = 0;
	reg [WL-1:0] zero_x_reg3 = 0;
	reg [WL-1:0] zero_x_reg4 = 0;
	reg [WL-1:0] zero_x_reg5 = 0;
	reg [WL-1:0] zero_x_reg6 = 0;
	reg [WL-1:0] zero_x_reg7 = 0;
	
	//---- Output signals of CCMs ----//
	wire [WL_ccm_2-1:0] y_ccm1, y_ccm8;
	wire [WL_ccm_14-1:0] y_ccm2, y_ccm7;
	wire [WL_ccm_44-1:0] y_ccm3, y_ccm6;
	wire [WL_ccm_74-1:0] y_ccm4, y_ccm5;
	
	//---- Output signals of OAs ----//
	wire [WL_oa7+1:0] z_oa7;
	wire [WL_oa6+1:0] z_oa6;
	wire [WL_oa5+1:0] z_oa5;
	wire [WL_oa4+1:0] z_oa4;
	wire [WL_oa3+1:0] z_oa3;
	wire [WL_oa2+1:0] z_oa2;
	//wire [WL_oa1+1:0] z_oa1;
	
	//---- Connect All CCMs ----//
	online_ccm_2	#Stage	zero_ccm1(.x(din_x_reg), .y(y_ccm1));
	online_ccm_14	#Stage	zero_ccm2(.x(zero_x_reg1), .y(y_ccm2));
	online_ccm_44	#Stage	zero_ccm3(.x(zero_x_reg2), .y(y_ccm3));
	online_ccm_74	#Stage	zero_ccm4(.x(zero_x_reg3), .y(y_ccm4));
	
	online_ccm_74	#Stage	zero_ccm5(.x(zero_x_reg4), .y(y_ccm5));
	online_ccm_44	#Stage	zero_ccm6(.x(zero_x_reg5), .y(y_ccm6));
	online_ccm_14	#Stage	zero_ccm7(.x(zero_x_reg6), .y(y_ccm7));
	online_ccm_2	#Stage	zero_ccm8(.x(zero_x_reg7), .y(y_ccm8));
	
	//---- Connect All Online Adders ----//
	online_adder #(stage_zero_oa7) zero_OA7(.x(y_ccm7),.y({8'b0,y_ccm8}),	.cin(1'b0), .z(z_oa7));
	online_adder #(stage_zero_oa6) zero_OA6(.x(y_ccm6),.y(z_oa7),	.cin(1'b0), .z(z_oa6));
	online_adder #(stage_zero_oa5) zero_OA5(.x(y_ccm5),.y(z_oa6),	.cin(1'b0), .z(z_oa5));
	online_adder #(stage_zero_oa4) zero_OA4(.x({2'b0,y_ccm4}),	.y(z_oa5),	.cin(1'b0), .z(z_oa4));
	online_adder #(stage_zero_oa3) zero_OA3(.x({6'b0,y_ccm3}),	.y(z_oa4),	.cin(1'b0), .z(z_oa3));
	online_adder #(stage_zero_oa2) zero_OA2(.x({10'b0,y_ccm2}),.y(z_oa3),	.cin(1'b0), .z(z_oa2));
	online_adder #(stage_zero_oa1) zero_OA1(.x({20'b0,y_ccm1}),.y(z_oa2),	.cin(1'b0), .z(data_out));
	
	always @ (posedge clk) begin
		if(!nrst) begin
			din_x_reg	<= 0;
			//y_out_reg	<= 0;
			{zero_x_reg1,zero_x_reg2,zero_x_reg3,zero_x_reg4,zero_x_reg5,zero_x_reg6,zero_x_reg7}	<= 'b0;
		end
		else begin
			if(enable) begin
				//y_out_reg	<= #1 z_oa1;
				din_x_reg	<= #1 din_x;
				zero_x_reg1		<= #1 din_x_reg;
				zero_x_reg2		<= #1 zero_x_reg1;
				zero_x_reg3		<= #1 zero_x_reg2;
				zero_x_reg4		<= #1 zero_x_reg3;
				zero_x_reg5		<= #1 zero_x_reg4;		
				zero_x_reg6		<= #1 zero_x_reg5;
				zero_x_reg7		<= #1 zero_x_reg6;	
			end
			else begin
				din_x_reg	<= 0;
				//y_out_reg	<= 0;
				{zero_x_reg1,zero_x_reg2,zero_x_reg3,zero_x_reg4,zero_x_reg5,zero_x_reg6,zero_x_reg7}	<= 'b0;
			end
		end
	end
	
	//assign data_out = y_out_reg;

endmodule
