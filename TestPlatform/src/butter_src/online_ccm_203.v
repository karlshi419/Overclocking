`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:48 02/11/2015 
// Design Name: 
// Module Name:    online_ccm_203 
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
//		203=128+64+8+2+1
//////////////////////////////////////////////////////////////////////////////////
module online_ccm_203(x,y);
parameter Stage = 4;

localparam s1 = 7;
localparam s2 = 6;
localparam s3 = 3;
localparam s4 = 1;
//localparam s5=0;

localparam WL 		= 2*Stage;
localparam WL_oa4	= 2*(Stage+s4);
localparam WL_oa3	= 2*(Stage+s2);
localparam WL_oa2	= 2*(Stage+s2+1);
localparam WL_oa1	= 2*(Stage+s1+1);

localparam WL_s3 	= 2*(Stage+s3);
localparam WL_s1 	= 2*(Stage+s1);

localparam WL_out = 2*(Stage+s1+2);

	input [WL-1:0] x;
	output[WL_out-1:0] y;
	
	wire [WL_s1-1:0] x_s1;
	wire [WL_oa3-1:0] x_s2, x_s3;
	wire [WL_oa4-1:0] x_s4, x_s5;
	
	wire [WL_oa4+1:0] sum_oa4;
	wire [WL_oa3+1:0] sum_oa3;
	wire [WL_oa2+1:0] sum_oa2;
	//wire [WL_oa1+1:0] sum_oa1;
	
	assign x_s5[WL-1:0]		 = x;
	assign x_s5[WL_oa4-1:WL] = 'b0;
	
	assign x_s4[WL_oa4-1:WL_oa4-WL] = x;
	assign x_s4[WL_oa4-WL-1:0]		  = 'b0;
	
	assign x_s3[WL_oa3-1:WL_s3] 	 = 'b0;
	assign x_s3[WL_s3-1:WL_s3-WL]  = x;
	assign x_s3[WL_s3-WL-1:0]		 = 'b0;
	
	assign x_s2[WL_oa3-1:WL_oa3-WL] = x;
	assign x_s2[WL_oa3-WL-1:0]		  = 'b0;
	
	assign x_s1[WL_s1-1:WL_s1-WL]	 = x;
	assign x_s1[WL_s1-WL-1:0]		 = 'b0;
	
	//---- Connect All Adders ----//
	online_adder #(Stage+s4) 	ccm203_OA4(.x(x_s4),.y(x_s5),.cin(1'b0),.z(sum_oa4));
	online_adder #(Stage+s2) 	ccm203_OA3(.x(x_s2),.y(x_s3),.cin(1'b0),.z(sum_oa3));
	online_adder #(Stage+s2+1)	ccm203_OA2(.x(sum_oa3),.y({10'b0,sum_oa4}),.cin(1'b0),.z(sum_oa2));
	online_adder #(Stage+s1+1)	ccm203_OA1(.x(sum_oa2),.y({2'b0,x_s1}),.cin(1'b0),.z(y));

endmodule
