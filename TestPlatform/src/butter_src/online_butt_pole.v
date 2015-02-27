`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:58:34 02/11/2015 
// Design Name: 
// Module Name:    online_butt_pole 
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
module online_butt_pole(clk, nrst, enable, din_x, data_out);
parameter Stage = 8;
localparam WL = Stage * 2;

localparam WL_yout = 2*(Stage+13);

localparam WL_ccm_178	= 2*(Stage+9);
localparam WL_ccm_214	= 2*(Stage+9);
localparam WL_ccm_135	= 2*(Stage+9);
localparam WL_ccm_65		= 2*(Stage+7);
localparam WL_ccm_19		= 2*(Stage+5);
localparam WL_ccm_3		= 2*(Stage+2);

localparam stage_pole_oa1 = (Stage+12);
localparam stage_pole_oa2 = (Stage+11);
localparam stage_pole_oa3 = (Stage+10);
localparam stage_pole_oa4 = (Stage+9);
localparam stage_pole_oa5 = (Stage+7);
localparam stage_pole_oa6 = (Stage+5);

localparam WL_pole_oa1 = 2*stage_pole_oa1;
localparam WL_pole_oa2 = 2*stage_pole_oa2;
localparam WL_pole_oa3 = 2*stage_pole_oa3;
localparam WL_pole_oa4 = 2*stage_pole_oa4;
localparam WL_pole_oa5 = 2*stage_pole_oa5;
localparam WL_pole_oa6 = 2*stage_pole_oa6;

	input clk, nrst;
	input enable;
	input [WL-1:0]	din_x;
	output [WL_yout-1:0] data_out;
	
	reg [WL-1:0] pole_x_reg1 = 0;
	reg [WL-1:0] pole_x_reg2 = 0;
	reg [WL-1:0] pole_x_reg3 = 0;
	reg [WL-1:0] pole_x_reg4 = 0;
	reg [WL-1:0] pole_x_reg5 = 0;
	reg [WL-1:0] pole_x_reg6 = 0;
	
	//---- Output signals of CCMs ----//
	wire [WL_ccm_178-1:0] 	y_ccm1;
	wire [WL_ccm_214-1:0] 	y_ccm2;
	wire [WL_ccm_135-1:0] 	y_ccm3;
	wire [WL_ccm_65-1:0] 	y_ccm4;
	wire [WL_ccm_19-1:0] 	y_ccm5;
	wire [WL_ccm_3-1:0] 		y_ccm6;
	
	//---- Output signals of OAs ----//
	wire [WL_pole_oa1+1:0] z_oa1;
	wire [WL_pole_oa2+1:0] z_oa2;
	wire [WL_pole_oa3+1:0] z_oa3;
	wire [WL_pole_oa4+1:0] z_oa4;
	wire [WL_pole_oa5+1:0] z_oa5;
	wire [WL_pole_oa6+1:0] z_oa6;
	
	//---- Connect All CCMs ----//
	online_ccm_178 #(Stage) pole_ccm1(.x(pole_x_reg1), .y(y_ccm1));
	online_ccm_214	#(Stage)	pole_ccm2(.x(pole_x_reg2), .y(y_ccm2));
	online_ccm_135 #(Stage) pole_ccm3(.x(pole_x_reg3), .y(y_ccm3));
	online_ccm_65	#(Stage)	pole_ccm4(.x(pole_x_reg4), .y(y_ccm4));
	online_ccm_19 	#(Stage) pole_ccm5(.x(pole_x_reg5), .y(y_ccm5));
	online_ccm_3	#(Stage)	pole_ccm6(.x(pole_x_reg6), .y(y_ccm6));
	
	//---- Connect All Online Adders ----//
	online_adder #(stage_pole_oa1) pole_oa1(.x({24'b0,din_x}),.y(z_oa2),.cin(1'b0),.z(data_out));
	online_adder #(stage_pole_oa2) pole_oa2(.x({4'b0,y_ccm1}),.y(z_oa3),	.cin(1'b0),.z(z_oa2));
	online_adder #(stage_pole_oa3) pole_oa3(.x({2'b0,y_ccm2}),.y(z_oa4),	.cin(1'b0),.z(z_oa3));
	online_adder #(stage_pole_oa4) pole_oa4(.x(y_ccm3),.y({2'b0,z_oa5}),	.cin(1'b0),.z(z_oa4));
	online_adder #(stage_pole_oa5) pole_oa5(.x(y_ccm4),.y({2'b0,z_oa6}),	.cin(1'b0),.z(z_oa5));
	online_adder #(stage_pole_oa6) pole_oa6(.x(y_ccm5),.y({6'b0,y_ccm6}),.cin(1'b0),.z(z_oa6));
	
	always @ (posedge clk) begin
		if(!nrst) begin
			{pole_x_reg1,pole_x_reg2,pole_x_reg3,pole_x_reg4,pole_x_reg5,pole_x_reg6}	<= 'b0;
		end
		else begin
			if(enable) begin
				pole_x_reg1		<= #1 din_x;
				pole_x_reg2		<= #1 pole_x_reg1;
				pole_x_reg3		<= #1 pole_x_reg2;
				pole_x_reg4		<= #1 pole_x_reg3;	
				pole_x_reg5		<= #1 pole_x_reg4;
				pole_x_reg6		<= #1 pole_x_reg5;	
			end
			else begin
				{pole_x_reg1,pole_x_reg2,pole_x_reg3,pole_x_reg4,pole_x_reg5,pole_x_reg6}	<= 'b0;
			end
		end
	end

endmodule
