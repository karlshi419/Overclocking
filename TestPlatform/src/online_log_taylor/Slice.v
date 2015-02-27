`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:25 03/12/2014 
// Design Name: 
// Module Name:    Slice 
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
//			modified to merge partial product generation
//			all y[1] = (a[1]&b[1]&(~b[0])) | ((~a[1])&(~b[1])&b[0]);
//			all y[0] = (a[0]&b[1]&(~b[0])) | ((~a[0])&(~b[1])&b[0]);
//////////////////////////////////////////////////////////////////////////////////
//module Slice(x1,x2,x3,a1,a2,a3,b,z1,z2);
module Slice(P1,P2,P3,x1,x2,x3,y,z1,z2);
	input [1:0] P1,P2,P3;	//P
	input [1:0] x1,x2;		//x
	input x3;					//x
	input [1:0] y;				//y
	
	output [1:0] z1,z2;
	
	
	//---- LUT1 ----
	wire L1outO6,L1outO5;		// output of LUT1
	lut1 l1(.P3n(P3[0]), .x3(x3), .y(y), .L1outO6(L1outO6), .L1outO5(L1outO5));

	
	//---- LUT2 ----	
	wire L2outO6,L2outO5;		//output of LUT2
	lut2 l2(.P2(P2), .x2(x2), .y(y), .L2outO6(L2outO6), .L2outO5(L2outO5));
	
	//---- LUT3 ----
	wire L3out;		//output of LUT3
	lut3 l3(.P2(P2), .x2p(x2[1]), .y(y), .L3out(L3out));
	
	//---- LUT4 ----
	wire L4outO6,L4outO5;		//output of LUT4
	lut4 l4(.P1(P1), .x1(x1), .y(y), .L4outO6(L4outO6), .L4outO5(L4outO5));
	
	//---- allocate input of slice ----
	wire [3:0] DI;
	wire [3:0] S;
	wire CYINIT;
	wire CI;

	assign DI = {L4outO5,L3out,L2outO5,L1outO5};
	assign S = {L4outO6,1'b0,L2outO6,L1outO6};
	assign CYINIT = P3[1];
	assign CI = 1'b0;
	
	
	
	//CARRY4: Fast Carry Logic Component Virtex-6
	wire [3:0] CO,O;
	CARRY4 CARRY4_inst (
		.CO(CO), 			// 4-bit carry out
		.O(O), 				// 4-bit carry chain XOR data out
		.CI(CI), 			// 1-bit carry cascade input
		.CYINIT(CYINIT), 	// 1-bit carry initialization
		.DI(DI), 			// 4-bit carry-MUX data in
		.S(S) 				// 4-bit carry-MUX select input
	);
	
	//---- allocate output of slice ----
	//assign {z1,z2} = {CO[3],O[3],CO[1],O[1]};
	assign {z1,z2} = {~CO[3],O[3],~CO[1],O[1]};
endmodule


(* LUT_MAP="yes" *)
module lut1(P3n, x3, y, L1outO6, L1outO5);
	input P3n;	//P3-
	input x3;
	input [1:0] y;
	output L1outO6, L1outO5;
	
	wire Xy3;
	assign Xy3 = (x3 & y[1] & (~y[0])) | (~x3 & (~y[1]) & y[0]);
	assign L1outO6 = ~(P3n) ^ Xy3;
	assign L1outO5 = Xy3;
endmodule

(* LUT_MAP="yes" *)
module lut2(P2,x2,y, L2outO6, L2outO5);
	input [1:0] P2;
	input [1:0] x2;
	input [1:0] y;
	output L2outO6, L2outO5;
	
	wire [1:0] Xy2;
	assign Xy2[1] = (x2[1] & y[1] & (~y[0])) | (~x2[1] & (~y[1]) & y[0]);
	assign Xy2[0] = (x2[0] & y[1] & (~y[0])) | (~x2[0] & (~y[1]) & y[0]);
	
	wire sum;
	assign sum = P2[1] ^ (~P2[0]) ^ Xy2[1];
	
	assign L2outO5 = ~Xy2[0];
	assign L2outO6 = sum ^ (~Xy2[0]);
endmodule

(* LUT_MAP="yes" *)
module lut3(P2, x2p, y, L3out);
	input [1:0] P2;
	input x2p;		//x2+
	input [1:0] y;
	output L3out;
	
	wire Xy2p;
	assign Xy2p	= (x2p & y[1] & (~y[0])) | (~x2p & (~y[1]) & y[0]);
	wire a,b,c;
	assign a = P2[1];
	assign b = ~P2[0];
	assign c = Xy2p;
	assign L3out = (a&b) | (c&(a^b));
endmodule

(* LUT_MAP="yes" *)
module lut4(P1,x1,y,L4outO6,L4outO5);
	input [1:0] P1;
	input [1:0] x1;
	input [1:0] y;
	output L4outO6, L4outO5;
	
	wire [1:0] Xy1;
	assign Xy1[1] = (x1[1] & y[1] & (~y[0])) | (~x1[1] & (~y[1]) & y[0]);
	assign Xy1[0] = (x1[0] & y[1] & (~y[0])) | (~x1[0] & (~y[1]) & y[0]);
	
	wire sum;
	assign sum = P1[1] ^ (~P1[0]) ^ Xy1[1];
	
	assign L4outO5 = ~Xy1[0];
	assign L4outO6 = sum ^ (~Xy1[0]);
	
endmodule

