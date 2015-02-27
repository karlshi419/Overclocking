`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:13 01/06/2014 
// Design Name: 
// Module Name:    RA_Main 
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
module RA_Main(x,y,hin,hout,zp,zn);
	input [1:0] x,y;
	input hin;
	output hout,zp,zn;
	
	wire a1,b1,cin1,cout1,s1;
	wire a2,b2,cin2,cout2,s2;
	
	assign a1 = x[1];
	assign b1 = ~x[0];
	assign cin1 = y[1];
		
	assign {cout1,s1} = a1 + b1 + cin1;	//the 1st Full-Adder
	assign hout = cout1;
	
	assign a2 = s1;
	assign b2 = ~y[0];
	assign cin2 = hin;
	
	assign {cout2,s2} = a2 + b2 + cin2;		//the 2nd Full-Adder
	assign zn = ~cout2;
	assign zp = s2;


endmodule
