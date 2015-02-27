`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:48:27 04/28/2014
// Design Name:
// Module Name:    online_mult
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
//	top-level module of digit-parallel online multiplier
//////////////////////////////////////////////////////////////////////////////////
module online_mult(x,y,z);
parameter N = 4;
localparam WL = N * 2;

	input [WL-1:0] x,y;
	output [2*WL-1:0] z;

	wire [WL+1:0] Pout[N-1:0];
	reg [WL+1:0] Pout_s1;
	
	wire [2*WL-1:WL] temp_z;
		
	// ---- Connect PM stages ----
	/*
	 * first stage
	 */
	always @(*)
	begin
		case(y[WL-1:WL-2])
			2'b10: 	Pout_s1[WL-1:0] <= x;
			2'b01:	Pout_s1[WL-1:0] <= ~x;
			default: Pout_s1[WL-1:0] <= 0;
		endcase
		Pout_s1[WL+1] 	<= Pout_s1[WL-1] & (~Pout_s1[WL-2]);
		Pout_s1[WL]		<= 1'b0;	
	end
		
	assign temp_z[2*WL-1:2*WL-2] = Pout_s1[WL+1:WL];	//first digit of output
	assign Pout[0] = Pout_s1;

	/*
	 * other stages
	 */
	genvar s;	//stage number
	generate
		for(s=1; s<N; s=s+1)
		begin:Stage
			PMStage #N PS_S(.x(x),.y(y[WL-2*s-1:WL-2*s-2]),.Pin(Pout[s-1]),.Pout(Pout[s]),.z(temp_z[2*WL-2*s-1:2*WL-2*s-2]));
		end
	endgenerate

	assign z[2*WL-1:WL+2] = temp_z[2*WL-1:WL+2];

	assign z[WL+1] = (Pout[N-1][WL+1] & ~Pout[N-1][WL] & ((~temp_z[WL+1] & ~temp_z[WL]) | (temp_z[WL+1] & temp_z[WL])))
							| (temp_z[WL+1] & ~temp_z[WL] & ((Pout[N-1][WL+1] & Pout[N-1][WL]) | (~Pout[N-1][WL+1] & ~Pout[N-1][WL])));

/*	assign z[WL]	= (|Pout[N-1][WL+1] & Pout[N-1][WL] & ((~temp_z[WL+1] & ~temp_z[WL]) | (temp_z[WL+1] & temp_z[WL])))
							| (~temp_z[WL+1] & temp_z[WL] & ((Pout[N-1][WL+1] & Pout[N-1][WL]) | (~Pout[N-1][WL+1] & ~Pout[N-1][WL])));
*/

	assign z[WL] = 1'b0;
	
	assign z[WL-1:0]=Pout[N-1][WL-1:0];


endmodule
