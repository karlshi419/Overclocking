`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:19 01/25/2015 
// Design Name: 
// Module Name:    chipscope 
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
module chipscope(clk, ila_data, trig0, vio_out);
parameter ila_data_width = 45;
	input clk;
	input [ila_data_width-1:0] ila_data;
	input [7:0] trig0;
	output [1:0] vio_out;
	
	wire [35:0] ctrl_ila;
	wire [35:0] ctrl_vio;
	wire [7:0] trig0;
	 
	icon sys_icon(
		.CONTROL0(ctrl_ila),	// INOUT BUS [35:0]
		.CONTROL1(ctrl_vio)	// INOUT BUS [35:0]
	);
	
	ila sys_ila (
    .CONTROL(ctrl_ila), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .DATA(ila_data), // IN BUS [38:0]
    .TRIG0(trig0) // IN BUS [7:0]
	);
	
	vio sys_vio (
    .CONTROL(ctrl_vio), // INOUT BUS [35:0]
    .ASYNC_OUT(vio_out) // OUT BUS [1:0]
	);


endmodule
