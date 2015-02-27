`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:41 02/11/2015 
// Design Name: 
// Module Name:    online_ccm_178 
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
//		178 = 128 + 32 + 16 + 2
//////////////////////////////////////////////////////////////////////////////////
module online_ccm_178(x,y);
parameter Stage = 4;

localparam s1 = 7;
localparam s2 = 5;
localparam s3 = 4;
localparam s4 = 1;

localparam WL 		= 2*Stage;

localparam WL_oa3	= 2*(Stage+s3);
localparam WL_oa2	= 2*(Stage+s1);
localparam WL_oa1	= 2*(Stage+s1+1);

localparam WL_s4 	= 2*(Stage+s4);
localparam WL_s3 	= 2*(Stage+s3);
localparam WL_s2 	= 2*(Stage+s2);
localparam WL_s1 	= 2*(Stage+s1);

localparam WL_out = 2*(Stage+s1+2);

	input [WL-1:0] x;
	output[WL_out-1:0] y;
	
	wire [WL_s3-1:0] x_s3,x_s4;
	wire [WL_s1-1:0] x_s1,x_s2;
	
	wire [WL_oa3+1:0] sum_oa3;
	wire [WL_oa2+1:0] sum_oa2;
	
	//2x
	assign x_s4[WL_s3-1:WL_s4]		= 'b0;
	assign x_s4[WL_s4-1:WL_s4-WL]	= x;
	assign x_s4[WL_s4-WL-1:0]		= 'b0;
	
	//16x
	assign x_s3[WL_s3-1:WL_s3-WL] = x;
	assign x_s3[WL_s3-WL-1:0]		= 'b0;
	
	//32x
	assign x_s2[WL_s1-1:WL_s2] 	= 'b0;
	assign x_s2[WL_s2-1:WL_s2-WL]	= x;
	assign x_s2[WL_s2-WL-1:0]		= 'b0;
	
	//128x
	assign x_s1[WL_s1-1:WL_s1-WL]	= x;
	assign x_s1[WL_s1-WL-1:0]		= 'b0;
	
	online_adder #(Stage+s3)	ccm134_OA3(.x(x_s3),.y(x_s4),.cin(1'b0),.z(sum_oa3));
	online_adder #(Stage+s1)	ccm134_OA2(.x(x_s1),.y(x_s2),.cin(1'b0),.z(sum_oa2));
	online_adder #(Stage+s1+1) ccm135_OA1(.x(sum_oa2),.y({6'b0,sum_oa3}),.cin(1'b0),.z(y));
	


endmodule
