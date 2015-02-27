`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:31:48 03/14/2014 
// Design Name: 
// Module Name:    RA_Top 
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
module RA_Top(xin,x_top,y_top,z);
parameter Stage = 6;
localparam WL = 2*Stage;

	input [WL-1:2] xin;		//Pin
	input [WL-5:0] x_top;	//all digits of top-input x			
	input [1:0] y_top;
	output [WL+1:0] z;
	
	wire [WL-1:0] x;
	wire [WL-1:0] y;
	
	assign x = {xin,2'b0};
	assign y = {4'b0,x_top};
	
						
	TopBottom TB(	.x1(x[WL-1:WL-2]),.x2(x[WL-3:WL-4]),.b(y_top),
						.z1(z[WL+1:WL]),.z2p(z[WL-1]),
						.aL(y[1:0]),.zL(z[2:1]));						
	
	genvar s;	// slice number
	
	generate
		for(s=1;s<(Stage/2);s=s+1)
		begin:Slice_no
				Slice S_carry(	.P1(x[4*s+1:4*s]),.P2(x[4*s-1:4*s-2]),.P3(x[4*s-3:4*s-4]),.y(y_top),
									.x1(y[4*s+1:4*s]),.x2(y[4*s-1:4*s-2]),.x3(y[4*s-3]),
									.z1(z[4*s+2:4*s+1]),.z2(z[4*s:4*s-1]));
		end
	endgenerate

	assign z[0] = 1'b0;
	

endmodule
