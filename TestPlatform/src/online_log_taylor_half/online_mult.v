`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:48:27 04/28/2014
// Design Name:
// Module Name:    PM_top
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
module online_mult(x,y,z);
parameter N = 8;
localparam WL = N * 2;

	input [WL-1:0] x,y;
	output [WL-1:0] z;

	// ---- Define partial products
	// only needs N partial products to calculate the MSD half
	wire [WL-1:0] Xy0;
	wire [WL-1:2] Xy1;
	wire [WL-1:4] Xy2;
	wire [WL-1:6] Xy3;
	wire [WL-1:8] Xy4;
	wire [WL-1:10] Xy5;
	wire [WL-1:12] Xy6;
	wire [WL-1:14] Xy7;


	//wire [WL+1:0] Pout[N-1:0];
	wire [WL+1:0] Pout0;
	wire [WL-1:0] Pout1;
	wire [WL-3:0] Pout2;
	wire [WL-5:0] Pout3;
	wire [WL-7:0] Pout4;
	wire [WL-9:0] Pout5;
	wire [WL-11:0] Pout6;
	wire [WL-13:0] Pout;		//final Pout, should have 4 bits


	//wire [2*WL-1:WL] temp_z;
	wire [WL-1:0] temp_z;

	// ---- generate partial products ----
	genvar i,S;

	generate
		for(S=0;S<N;S=S+1)
		begin:Xy_number
			for(i=WL-1;i>=2*S;i=i-1)
			begin:Xy_value
				if(S==0)
					assign Xy0[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else if(S==1)
					assign Xy1[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else if(S==2)
					assign Xy2[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else if(S==3)
					assign Xy3[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else if(S==4)
					assign Xy4[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else if(S==5)
					assign Xy5[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else if(S==6)
					assign Xy6[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
				else
					assign Xy7[i] = (x[i]&y[WL-2*S-1]&(~y[WL-2*S-2])) | ((~x[i])&(~y[WL-2*S-1])&y[WL-2*S-2]);
			end
		end
	endgenerate

	// ---- Connect PM stages ----
	PMS1 #(N) 		PS_S0(.Xy(Xy0),.Pout(Pout0),.z(temp_z[WL-1:WL-2]));
	PMStage #(N-1) 	PS_S1(.Xy(Xy1),.Pin(Pout0), .Pout(Pout1),.z(temp_z[WL-3:WL-4]));
	PMStage #(N-2) 	PS_S2(.Xy(Xy2),.Pin(Pout1), .Pout(Pout2),.z(temp_z[WL-5:WL-6]));
	PMStage #(N-3) 	PS_S3(.Xy(Xy3),.Pin(Pout2), .Pout(Pout3),.z(temp_z[WL-7:WL-8]));
	PMStage #(N-4) 	PS_S4(.Xy(Xy4),.Pin(Pout3), .Pout(Pout4),.z(temp_z[WL-9:WL-10]));
	PMStage #(N-5) 	PS_S5(.Xy(Xy5),.Pin(Pout4), .Pout(Pout5),.z(temp_z[WL-11:WL-12]));
	PMStage #(N-6) 	PS_S6(.Xy(Xy6),.Pin(Pout5), .Pout(Pout6),.z(temp_z[WL-13:WL-14]));
	PMStage #(N-7) 	PS_S7(.Xy(Xy7),.Pin(Pout6), .Pout(Pout),.z(temp_z[WL-15:WL-16]));

	assign z[WL-1:2] = temp_z[WL-1:2];

	//assign z[1:0] = Pout2[]


	assign z[1] = (Pout[3] & ~Pout[2] & ((~temp_z[1] & ~temp_z[0]) | (temp_z[1] & temp_z[0])))
							| (temp_z[1] & ~temp_z[0] & ((Pout[3] & Pout[2]) | (~Pout[3] & |Pout[2])));

	assign z[0]	= (Pout[3] & Pout[2] & ((~temp_z[1] & ~temp_z[0]) | (temp_z[1] & temp_z[0])))
							| (~temp_z[1] & temp_z[0] & ((Pout[3] & Pout[2]) | (~Pout[3] & |Pout[2])));



endmodule
