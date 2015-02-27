`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:34 04/28/2014 
// Design Name: 
// Module Name:    PMStage 
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
module PMStage(x,y,Pin,Pout,z);
parameter N = 4;				//digits
localparam WL = N * 2;	//bits


	input [WL-1:0] x;			//all digits of top-input x
	input [1:0] y;
	input [WL+1:0] Pin;		//2 integer digits and N-1 frac digits
	output [WL+1:0] Pout;
	output [1:0] z;
	
	wire [WL+5:0] temp_P;
	
	// ---- Connect Redundant Adder
	RA_Top #(N+2) RA(.xin(Pin),.x_top(x),.y_top(y),.z(temp_P));
	
	// ---- initialize the LUT6 for selecting z+ ---------------
	LUT6 #(
		.INIT(64'h4F0420F220F24F04)  // Specify LUT Contents, see 20140420_OnlineMult_ErrorDistribution.xlsx
	) LUT6_zp (
   .O(z[1]),   // LUT general output
   .I0(temp_P[WL-2]), // LUT input	-- LSB
   .I1(temp_P[WL-1]), // LUT input
   .I2(temp_P[WL]), // LUT input
   .I3(temp_P[WL+1]), // LUT input
   .I4(temp_P[WL+2]), // LUT input
   .I5(temp_P[WL+3])  // LUT input 	-- MSB
	);
	
	// ---- initialize the LUT6 for selecting z- ---------------
	LUT6 #(
		.INIT(64'h00B0DB0DDB0D00B0)  // Specify LUT Contents, see 20140420_OnlineMult_ErrorDistribution.xlsx
	) LUT6_zn (
   .O(z[0]),   // LUT general output
   .I0(temp_P[WL-2]), // LUT input	-- LSB
   .I1(temp_P[WL-1]), // LUT input
   .I2(temp_P[WL]), // LUT input
   .I3(temp_P[WL+1]), // LUT input
   .I4(temp_P[WL+2]), // LUT input
   .I5(temp_P[WL+3])  // LUT input	-- MSB
	);
	
	// ---- initialize the LUT6 for the MSD of Pout --------------
	LUT6 #(
		.INIT(64'h4044F40FF40F4044)  // Specify LUT Contents, see 20140420_OnlineMult_ErrorDistribution.xlsx
	) LUT6_pmsd (
   .O(Pout[WL+1]),   // LUT general output
   .I0(temp_P[WL-2]), // LUT input	-- LSB
   .I1(temp_P[WL-1]), // LUT input
   .I2(temp_P[WL]), // LUT input
   .I3(temp_P[WL+1]), // LUT input
   .I4(temp_P[WL+2]), // LUT input
   .I5(temp_P[WL+3])  // LUT input	-- MSB
	);
	
	// ---- combine all digits to generate Pout
	assign Pout[WL:0] = {1'b0,temp_P[WL-1:0]};

endmodule
