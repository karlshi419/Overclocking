`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:48:47 02/10/2015 
// Design Name: 
// Module Name:    online_ccm_2 
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
module online_ccm_2(x,y);
parameter Stage = 4;

localparam shift = 1;

localparam WL		= 2*Stage;
localparam WL_oa	= 2*(Stage+shift);
localparam WL_out = 2*(Stage+shift+1);

	input [WL-1:0] x;
	output [WL_oa-1:0] y;
	
	wire [WL_oa-1:0] x_shift;	//x after shift

	assign x_shift[WL_oa-1: WL_oa-WL] 	= x;
	assign x_shift[WL_oa-WL-1:0]			= 'b0;
	
	assign y = x_shift;

endmodule
