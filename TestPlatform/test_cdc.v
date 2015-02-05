`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:09:34 01/25/2015
// Design Name:   platform_top
// Module Name:   G:/FPGA/FIR_img/ChipScope/CDC/ClockDomainCrossing/test_cdc.v
// Project Name:  ClockDomainCrossing
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: platform_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define Clock 10
`define Clock_ip 5
module test_cdc;

	// Inputs
	reg clk;
	reg clk_ip;
	reg nrst;
	reg write_enable;
	reg read_enable;

	// Outputs
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	platform_top uut (
		.clk(clk), 
		.nrst(nrst), 
		.clk_ip(clk_ip),
		.write_enable(write_enable), 
		.read_enable(read_enable), 
		.led(led)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		clk_ip = 0;
		write_enable = 0;
		read_enable = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		nrst = 1;
		#(`Clock*5);
		write_enable = 1;
		
		#(`Clock*550);
		write_enable = 0;
		read_enable = 1;
		
		#(`Clock*550);
		$stop;

	end
	
	always begin
		#(`Clock*0.5) clk = ~clk;
	end
	
	always begin
		#(`Clock_ip*0.5) clk_ip = ~clk_ip;
	end
      
endmodule

