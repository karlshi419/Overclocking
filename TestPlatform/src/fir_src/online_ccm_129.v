`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:48:30 01/30/2015 
// Design Name: 
// Module Name:    online_ccm_129 
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
module online_ccm_129(x,y);
parameter Stage = 4;
localparam shift = 7;

localparam WL 		= 2*Stage;
localparam WL_oa	= 2*(Stage+shift);		//WL of OA inputs
localparam WL_out = 2*(Stage+shift+1);

	input [WL-1:0] x;
	
	output [WL_out-1:0] y;
	
	wire [WL_oa-1:0] x_shift;	//x after shift
	wire [WL_oa-1:0] x_org;	//original x with 0s padding at MSDs
	
	assign x_org[WL_oa-1:WL] = 'b0;
	assign x_org[WL-1:0]		  = x;

	assign x_shift[WL_oa-1: WL_oa-WL] = x;
	assign x_shift[WL_oa-WL-1:0]			= 'b0;
	
	online_adder #(Stage+shift) OA_ccm(.x(x_org),.y(x_shift),.cin(1'b0),.z(y));

endmodule
