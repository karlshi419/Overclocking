`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:42 01/29/2015 
// Design Name: 
// Module Name:    online_adder_unit 
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
module online_adder_unit(x,y,cin,cout,zp,zn);

	input [1:0] x,y;
	input cin;
	output cout,zp,zn;

	wire a1,b1,cin1,cout1,s1;
	wire a2,b2,cin2,cout2,s2;
	
	assign a1 = x[1];
	assign b1 = ~x[0];
	assign cin1 = y[1];
	
	assign {cout1,s1} = a1 + b1 + cin1;	// the first Full-Adder
	assign cout = cout1;
	
	assign a2 = s1;
	assign b2 = ~y[0];
	assign cin2 = cin;
	
	assign {cout2,s2} = a2 + b2 + cin2;
	assign zp = s2;
	assign zn = ~cout2;


endmodule
