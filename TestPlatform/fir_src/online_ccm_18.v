`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:44 01/30/2015 
// Design Name: 
// Module Name:    online_ccm_18 
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
//		CCM: y = 18x = 16x+2x
//////////////////////////////////////////////////////////////////////////////////
module online_ccm_18(x,y);
parameter Stage = 4;

localparam s1 = 4;
localparam s2 = 1;

localparam WL 		= 2*Stage;
localparam WL_oa	= 2*(Stage+s1);		//WL of OA inputs
localparam WL_s2	= 2*(Stage+s2);
localparam WL_out = 2*(Stage+s1+1);

	input [WL-1:0] x;
	output [WL_out-1:0] y;
	
	wire [WL_oa-1:0] x_s1, x_s2;
	
	assign x_s1[WL_oa-1:WL_oa-WL] = x;
	assign x_s1[WL_oa-WL-1:0]		= 'b0;
	
	assign x_s2[WL_oa-1:WL_s2] 	= 'b0;
	assign x_s2[WL_s2-1:WL_s2-WL]	= x;
	assign x_s2[WL_s2-WL-1:0]		= 'b0;
	
	online_adder #(Stage+s1) OA_ccm(.x(x_s1),.y(x_s2),.cin(1'b0),.z(y));

endmodule
