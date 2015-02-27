`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:09 04/28/2014 
// Design Name: 
// Module Name:    PMS1 
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
//		THE very first stage, don't need redundant adders
//////////////////////////////////////////////////////////////////////////////////
module PMS1(Xy,Pout,z);
parameter N = 4;
localparam WL = N*2;

	input [WL-1:0] Xy;
	output [WL+1:0] Pout;
	output [1:0] z;
	
	assign z[1] = Xy[WL-1] & (~Xy[WL-2]);
	assign z[0] = 1'b0;
	assign Pout[WL+1] = Xy[WL-1] & (~Xy[WL-2]);
	assign Pout[WL:0] = {1'b0,Xy};


endmodule
