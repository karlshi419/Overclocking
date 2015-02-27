`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:40 02/11/2015 
// Design Name: 
// Module Name:    online_ccm_41 
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
//			41 = 32+8+1
//////////////////////////////////////////////////////////////////////////////////
module online_ccm_41(x,y);
parameter Stage = 4;

localparam s1 = 5;
localparam s2 = 3;
localparam s3 = 1;

localparam WL 		= 2*Stage;
localparam WL_oa1	= 2*(Stage+s1);		//WL of OA inputs
localparam WL_oa2 = 2*(Stage+s2);
localparam WL_s2	= 2*(Stage+s2);
localparam WL_s3	= 2*(Stage+s3);
localparam WL_out = 2*(Stage+s1+1);

	input [WL-1:0] x;
	output[WL_out-1:0] y;
	
	wire [WL_oa1-1:0] x_s1;
	wire [WL_oa2-1:0] x_s2, x_s3;
	
	wire [WL_oa2+1:0] sum_oa2;
	
	assign x_s1[WL_oa1-1:WL_oa1-WL]	= x;
	assign x_s1[WL_oa1-WL-1:0]			= 'b0;
	
	assign x_s2[WL_s2-1:WL_s2-WL]	= x;
	assign x_s2[WL_s2-WL-1:0]		= 'b0;
	
	assign x_s3[WL_s2-1:WL_s3] 	= 'b0;
	assign x_s3[WL_s3-1:WL_s3-WL]	= x;
	assign x_s3[WL_s3-WL-1:0]		= 'b0;
	
	//---- Connect All Adders ----//
	online_adder #(Stage+s2) ccm41_OA2(.x(x_s2),.y(x_s3),.cin(1'b0),.z(sum_oa2));
	online_adder #(Stage+s1) ccm41_OA1(.x(x_s1),.y({2'b0,sum_oa2}),.cin(1'b0),.z(y));
	


endmodule
