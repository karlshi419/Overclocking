`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:26:21 01/28/2015
// Design Name:   dut_top
// Module Name:   G:/FPGA/FIR_img/ChipScope/BRAM/ROM/platform_input_rom/test_dut_top.v
// Project Name:  platform_input_rom
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dut_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_dut_top;

	// Inputs
	reg clk;
	reg nrst;
	reg enable;
	reg fifo_full;

	// Outputs
	wire fifo_wr_en;
	wire [7:0] dut_dout;
	
	localparam Clock=10;
	localparam one_ns = 1000;

	// Instantiate the Unit Under Test (UUT)
	dut_top uut (
		.clk(clk), 
		.nrst(nrst), 
		.enable(enable), 
		.fifo_full(fifo_full), 
		.fifo_wr_en(fifo_wr_en), 
		.dut_dout(dut_dout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		nrst = 0;
		enable = 0;
		fifo_full = 0;

		#50000 nrst = 1;
        
		// Add stimulus here
		#(500*Clock*one_ns);
		enable = 1;
		
		#(1000*Clock*one_ns);
		$stop;

	end
	
	always begin
		#(Clock* one_ns* 0.5) clk=~clk;
	end
      
endmodule

