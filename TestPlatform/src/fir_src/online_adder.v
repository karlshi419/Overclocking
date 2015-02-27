`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:58:47 01/29/2015 
// Design Name: 
// Module Name:    online_adder 
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
module online_adder(x,y,cin,z);
parameter Stage = 4;
localparam WL = Stage * 2;

	input [WL-1:0] x;
	input [WL-1:0] y;
	input cin;
	output [WL+1:0] z;
	
	wire [Stage-1:0] h;
	wire [WL:1] temp_z;
	
	genvar gv_i;	//stage number
	
	generate
		for(gv_i=0; gv_i<Stage; gv_i=gv_i+1)
		begin:label
			if (gv_i==0)
				online_adder_unit OA_0(.x(x[1:0]),.y(y[1:0]),.cin(1'b0),.cout(h[0]),.zp(temp_z[1]),.zn(temp_z[2]));
			else
				online_adder_unit OA(.x(x[2*gv_i+1:2*gv_i]),.y(y[2*gv_i+1:2*gv_i]),.cin(h[gv_i-1]),.cout(h[gv_i]),.zp(temp_z[gv_i*2+1]),.zn(temp_z[gv_i*2+2]));
		end
	endgenerate
	
	assign z[WL+1] = h[Stage-1];
	assign z[WL:1] = temp_z[WL:1];
	assign z[0]		= cin;

endmodule
