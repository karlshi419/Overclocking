`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:23 01/28/2015 
// Design Name: 
// Module Name:    adder 
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
module adder(clk, nrst, enable, din_x, din_y, data_out);
parameter WL = 8;
	input clk, nrst;
	input enable;
	input [WL-1:0] din_x, din_y;
	output [WL-1:0] data_out;
	
	reg [WL-1:0] temp_data;
	
	always @ (posedge clk) begin
		if(!nrst)	temp_data <= 0;
		else begin
			if(enable)
				temp_data <= din_x + din_y;
			else
				temp_data <= 0;
		end
	end
	
	assign data_out = temp_data;


endmodule
