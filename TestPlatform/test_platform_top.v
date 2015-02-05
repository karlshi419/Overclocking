`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:41:11 01/29/2015
// Design Name:   platform_top
// Module Name:   G:/FPGA/FIR_img/ChipScope/BRAM/ROM/platform_input_rom/test_platform_top.v
// Project Name:  platform_input_rom
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

module test_platform_top;

	// Inputs
	reg sys_clk;
	reg sys_rst;
	reg read_enable;
	reg write_enable;

	// Outputs
	wire [7:0] led;
	
	localparam Clock=10;
	localparam one_ns = 1000;

	// Instantiate the Unit Under Test (UUT)
	platform_top uut (
		.sys_clk(sys_clk), 
		.sys_rst(sys_rst), 
		.read_enable(read_enable), 
		.write_enable(write_enable), 
		.led(led)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		sys_rst = 1;
		read_enable = 0;
		write_enable = 0;

		#50000 sys_rst = 0;
        
		// Add stimulus here
		#(500*Clock*one_ns);
		write_enable = 1;
		#(500*Clock*one_ns);
		read_enable = 1;
		
		#(1000*Clock*one_ns);
		$stop;

	end
	
	always begin
		#(Clock* one_ns* 0.5) sys_clk=~sys_clk;
	end
      
      
endmodule

