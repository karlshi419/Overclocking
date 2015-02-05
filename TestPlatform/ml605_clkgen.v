`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:57 01/22/2015 
// Design Name: 
// Module Name:    ml605_clkgen 
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
//			system clock generation based on differential clock inputs
//				sys_clk_p, sys_clk_n
//////////////////////////////////////////////////////////////////////////////////
module ml605_clkgen(sys_clk_p, sys_clk_n, clk_200);
	input sys_clk_p, sys_clk_n;
	output clk_200;
	
	wire clk_ref_ibufg;
	wire clk_ref_bufg;
	
	//---- connect differential clock signal ----//
	IBUFGDS #(
		.DIFF_TERM("FALSE"), // Differential Termination
		.IOSTANDARD("DEFAULT") // Specify the input I/O standard
	) IBUFGDS_inst (
		.O(clk_ref_ibufg), // Clock buffer output
		.I(sys_clk_p), // Diff_p clock buffer input (connect directly to top-level port)
		.IB(sys_clk_n) // Diff_n clock buffer input (connect directly to top-level port)
	);

	//---- Global clock buffer
	BUFG u_bufg_clk_ref
		(
		 .O (clk_ref_bufg),
       .I (clk_ref_ibufg)
      );
	assign clk_200 = clk_ref_bufg;		//ML605 single 200MHz clock source
	

endmodule
