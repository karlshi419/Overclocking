`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:35 02/10/2015 
// Design Name: 
// Module Name:    online_iir_pole 
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
module online_iir_pole(clk, nrst, enable, din_x, data_out);
parameter Stage = 8;
localparam WL = Stage * 2;

localparam WL_yout = 2*(Stage+10);

localparam WL_ccm_117	= 2*(Stage+8);
localparam WL_ccm_24		= 2*(Stage+5);

localparam stage_pole_oa1 = (Stage+8);
localparam stage_pole_oa2 = (Stage+9);

localparam WL_pole_oa1 = 2*stage_pole_oa1;
localparam WL_pole_oa2 = 2*stage_pole_oa2;

	input clk, nrst;
	input enable;
	input [WL-1:0]	din_x;
	output [WL_yout-1:0] data_out;
	
	//reg [WL-1:0] din_x_reg 		= 0;
	//reg [WL_yout-1:0]  y_out_reg = 0;
	
	reg [WL-1:0] pole_x_reg1 = 0;
	reg [WL-1:0] pole_x_reg2 = 0;
	reg [WL-1:0] pole_x_reg3 = 0;
	reg [WL-1:0] pole_x_reg4 = 0;
	
	//---- Output signals of CCMs ----//
	wire [WL_ccm_117-1:0] 	y_ccm1;
	wire [WL_ccm_24-1:0] 	y_ccm2;
	
	//---- Output signals of OAs ----//
	//wire [WL_pole_oa2+1:0] z_oa2;
	wire [WL_pole_oa1+1:0] z_oa1;
	
	//---- Connect All CCMs ----//
	online_ccm_117 #(Stage) ccm1(.x(pole_x_reg2), .y(y_ccm1));
	online_ccm_24	#(Stage)	ccm2(.x(pole_x_reg4), .y(y_ccm2));
	
	//---- Connect All Online Adders ----//
	online_adder #(stage_pole_oa1) pole_oa1(.x(y_ccm1),.y({6'b0,y_ccm2}),.cin(1'b0),.z(z_oa1));
	online_adder #(stage_pole_oa2) pole_oa2(.x(z_oa1),.y({18'b0,din_x}),.cin(1'b0),.z(data_out));
	
	always @ (posedge clk) begin
		if(!nrst) begin
			//din_x_reg	<= 0;
			//y_out_reg	<= 0;
			{pole_x_reg1,pole_x_reg2,pole_x_reg3,pole_x_reg4}	<= 'b0;
		end
		else begin
			if(enable) begin
				//y_out_reg	<= #1 z_oa2;
				//din_x_reg	<= #1 din_x;
				pole_x_reg1		<= #1 din_x;
				pole_x_reg2		<= #1 pole_x_reg1;
				pole_x_reg3		<= #1 pole_x_reg2;
				pole_x_reg4		<= #1 pole_x_reg3;	
			end
			else begin
				//din_x_reg	<= 0;
				//y_out_reg	<= 0;
				{pole_x_reg1,pole_x_reg2,pole_x_reg3,pole_x_reg4}	<= 'b0;
			end
		end
	end
	
	//assign data_out = y_out_reg;

endmodule
