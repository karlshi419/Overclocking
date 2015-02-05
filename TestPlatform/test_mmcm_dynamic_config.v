`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:06:49 01/27/2015
// Design Name:   platform_top
// Module Name:   G:/FPGA/FIR_img/ChipScope/CDC/cdc_mmcm_dynamic_config/test_mmcm_dynamic_config.v
// Project Name:  cdc_mmcm_dynamic_config
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

module test_mmcm_dynamic_config;

	// Inputs
	reg clk;
	reg sys_rst;
	reg read_enable;
	reg write_enable;

	// Outputs
	wire [7:0] led;
	
	localparam Clock=10;
	localparam one_ns = 1000;

	// Instantiate the Unit Under Test (UUT)
	platform_top uut (
		.sys_clk(clk),
		.sys_rst(sys_rst), 
		.read_enable(read_enable),
		.write_enable(write_enable),
		.led(led)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		sys_rst = 1;
		write_enable = 0;
		read_enable = 0;

		// Wait 100 ns for global reset to finish
		#50000 sys_rst = 0;
        
		// Add stimulus here
		#(300*Clock*one_ns);
		write_enable = 1;
		
		#(300*Clock*one_ns);
		read_enable = 1;
		#(300*Clock*one_ns);
		$stop;

	end
	
	always begin
		#(Clock* one_ns* 0.5) clk=~clk;
	end
      
endmodule

