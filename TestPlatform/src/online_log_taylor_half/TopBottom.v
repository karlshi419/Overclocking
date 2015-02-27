`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:19:42 03/13/2014 
// Design Name: 
// Module Name:    TopBottom 
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
//		combination of remening MSD & LSD logic, when overall word-length is EVEN!
//////////////////////////////////////////////////////////////////////////////////
module TopBottom(x1,x2,z1,z2p,aL,zL,b);

	input [1:0] x1,x2;	//Pin
	input [1:0] b;			//1 digit of y
	input [1:0] aL;	//input of LSD
	output [1:0] z1;
	output z2p;
	output [1:0] zL;		//output of LSD			
	
	
	//---- MSD Slice -------------------------------------------------------
	
	//---- LUT1 ----
	wire L1out;	
	assign L1out = x2[1] ^ (~x2[0]);
	
	//---- LUT2 ----
	wire L2outO6, L2outO5;
	assign L2outO6 = ~(x1[1] ^ (~x1[0]));
	assign L2outO5 = x1[1] ^ (~x1[0]);
		
	//---- LUT3 ----
	wire L3out;
	assign L3out = x1[1] & (~x1[0]);
	 
	//---- allocate input of slice ----
	wire [3:0] DI;
	wire [3:0] S;
	wire CYINIT;
	wire CI;
	
	assign DI = {1'b0,1'b0,L2outO5,x2[1]};
	assign S  = {1'b0,1'b0,L2outO6,L1out};
	assign CYINIT = 1'b0;
	assign CI = 1'b0;
	 
	//CARRY4: Fast Carry Logic Component Virtex-6
	wire [3:0] CO,O;
	CARRY4 CARRY4_inst_MSD (
		.CO(CO), 			// 4-bit carry out
		.O(O), 				// 4-bit carry chain XOR data out
		.CI(CI), 			// 1-bit carry cascade input
		.CYINIT(CYINIT), 	// 1-bit carry initialization
		.DI(DI), 			// 4-bit carry-MUX data in
		.S(S) 				// 4-bit carry-MUX select input
	);
	
	
	//---- allocate output of slice ----
	assign {z1,z2p} = {L3out,~CO[1],O[1]};	//--real results but need 1 extra LUT
	
	
	//---- LSD Slice -------------------------------------------------------
	
	// see logbook P135

	//assign zL[1] = ~(xL[1]^(~xL[0])^((aL[1]&b[1]&(~b[0])) | ((~aL[1])&(~b[1])&b[0]))) | ((xL[1]^(~xL[0])^(aL[1]))&aL[0]);
	//assign zL[0] = (xL[1]^(~xL[0])^aL[1]) ^ (~aL[0]);
	
	//assign zL[1] = (((aL[1]&b[1]&(~b[0])) | ((~aL[1])&(~b[1])&b[0]))) | (~aL[1] & aL[0]);
	//assign zL[0] = aL[1] ^ aL[0];
	
	/*wire [1:0] yL;
	wire [1:0] temp_zL;
	assign yL[1] = ~((aL[1]&b[1]&(~b[0])) | ((~aL[1])&(~b[1])&b[0]));
	assign yL[0] = ~((aL[0]&b[1]&(~b[0])) | ((~aL[0])&(~b[1])&b[0]));
	assign temp_zL = yL[1] + yL[0];
	assign zL[1] = ~temp_zL[1];
	assign zL[0] = temp_zL[0];
	*/
	lsd_slice lsd(.xL(aL), .y(b), .zL(zL));
	
endmodule

(* LUT_MAP="yes" *)
module lsd_slice(xL, y, zL);
	input [1:0] xL;
	input [1:0] y;
	output [1:0] zL;
	
	/*wire [1:0] yL;
	wire [1:0] temp_zL;
	assign yL[1] = ~((aL[1]&b[1]&(~b[0])) | ((~aL[1])&(~b[1])&b[0]));
	assign yL[0] = ~((aL[0]&b[1]&(~b[0])) | ((~aL[0])&(~b[1])&b[0]));
	assign temp_zL = yL[1] + yL[0];
	assign zL[1] = ~temp_zL[1];
	assign zL[0] = temp_zL[0];
	*/
	
	wire [1:0] Xy;
	assign Xy[1] = (xL[1]&y[1]&(~y[0])) | ((~xL[1])&(~y[1])&y[0]);
	assign Xy[0] = (xL[0]&y[1]&(~y[0])) | ((~xL[0])&(~y[1])&y[0]);
	
	wire sum;
	assign sum = ~Xy[1];
	
	assign zL[0] = sum ^ (~Xy[0]);
	assign zL[1] = ~(sum & (~Xy[0]));
	
endmodule
