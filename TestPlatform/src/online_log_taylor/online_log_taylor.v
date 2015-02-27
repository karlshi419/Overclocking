`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:30 02/23/2015 
// Design Name: 
// Module Name:    online_log_taylor 
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
//		y=0.43(x-1)-0.22(x-1)^2
//////////////////////////////////////////////////////////////////////////////////
module online_log_taylor(clk,nrst,enable,din_x,data_out);
parameter Stage = 8;
localparam WL = Stage * 2;

localparam S_mult = 2*Stage;
localparam WL_mult = 2*S_mult;

localparam C0 = 16'h4000;	//-1
localparam C1 = 16'h0a2a;	//0.43
localparam C2 = 16'h02a0;	//0.22

localparam WL_yout = 2*(S_mult+1);

	input clk, nrst;
	input enable;
	input [WL-1:0] din_x;
	output [WL_yout-1:0] data_out;
	
	reg [WL-1:0] din_x_reg = 0;
	reg [WL_yout-1:0] y_out_reg = 0;
	
	//---- Output signals of OAs ----//
	wire [WL+1:0] 			temp_oa1_out;
	wire [WL_mult+1:0]	oa2_out;
	wire [WL-1:0] 			oa1_out;
	assign oa1_out = temp_oa1_out[WL+1:2];
	
	//---- I/O signals of OMs ----//
	wire [WL_mult-1:0] om1_out, om2_out, om3_out;
	wire [WL-1:0]		 om3_in;
	assign om3_in = om2_out[WL_mult-1:WL];
	
	online_adder 	#(Stage)	OA1(.x(din_x_reg),.y(C0),		.cin(1'b0),.z(temp_oa1_out));
	online_mult		#(Stage)	OM1(.x(oa1_out),	.y(C1),		.z(om1_out));
	online_mult		#(Stage)	OM2(.x(oa1_out),	.y(oa1_out),.z(om2_out));
	online_mult		#(Stage)	OM3(.x(om3_in),	.y(C2),		.z(om3_out));
	online_adder 	#(S_mult)OA2(.x(om1_out),	.y(om3_out),.cin(1'b0),.z(oa2_out));

	always @ (posedge clk) begin
		if(!nrst) begin
			din_x_reg	<= 0;
			y_out_reg	<= 0;
		end
		else begin
			if(enable) begin
				y_out_reg	<= #1 oa2_out;
				din_x_reg	<= #1 din_x;
			end
			else begin
				din_x_reg	<= 0;
				y_out_reg	<= 0;
			end
		end
	end
	
	assign data_out = y_out_reg;

endmodule
