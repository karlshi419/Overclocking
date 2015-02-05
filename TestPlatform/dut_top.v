`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:44 01/25/2015 
// Design Name: 
// Module Name:    dut_top 
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
module dut_top(clk, nrst, enable, fifo_full, fifo_wr_en, dut_dout);
parameter data_width = 16;
parameter rom_depth_bits = 9;
//parameter rom_depth = 512;
localparam rom_depth = 2^rom_depth_bits;

parameter data_width_out = 40;

	input clk, nrst;
	input enable, fifo_full;
	output reg fifo_wr_en;
	output reg [data_width_out-1:0] dut_dout;
	
	// sync registers for enable
	reg en_r1, en_r2;
	wire dut_en;
	
	reg fifo_full_r;
	wire [data_width_out-1:0] temp_dut_dout;
	
	//---- Input ROMs ----//
	//reg [data_width:0] rom_addr = 0;
	reg [rom_depth_bits-1:0] rom_addr = 0;
	 
	(* rom_style = "block" *)
	reg [data_width-1:0] rom_in_1[0:rom_depth-1];

	
	reg [data_width-1:0] rom_dout_1;	//rom data output, should be connected to DUT
	reg [data_width-1:0] rom_dout_1_r = 0;

	
	initial begin
		$readmemb("./matlab/rom_in.txt", rom_in_1, 0, rom_depth-1);
		
	end
	
	//-- ROM address and data generation --//
	always @(posedge clk) begin
		if(!nrst)	begin
			rom_addr 	<= 0;
		end
		else
			if(dut_en) begin
				if(!(&rom_addr))
					rom_addr 	<= rom_addr + 1;
			end
			else
				rom_addr <= 0;
	end
	
	always @(posedge clk) begin
		if(dut_en) begin
			rom_dout_1_r	<= rom_in_1[rom_addr];
		end
	end
	
	always @ (posedge clk) begin
		if(!nrst) begin
			rom_dout_1	<= 0;
		end
		else 
			if(dut_en) begin
				rom_dout_1	<= rom_dout_1_r;
				//rom_dout_2	<= rom_dout_2_r;
			end
			else begin
				rom_dout_1	<= 0;
				//rom_dout_2	<= 0;
			end
	end
	
	//---- Sync Control Signals across clock domain ----//
	always @ (posedge clk) begin
		if(!nrst) begin
			en_r1 <= 0;
			en_r2 <= 0;
		end
		else begin
			en_r1 		<= enable;
			en_r2 		<= en_r1;
		end
	end
	
	always @ (posedge clk) begin
		if(!nrst) begin
			fifo_full_r <= 0;
			fifo_wr_en	<= 0;
			dut_dout		<= 0;
		end
		else begin
			fifo_full_r	<= fifo_full;
			fifo_wr_en	<= en_r2 & (!fifo_full);
			dut_dout		<= temp_dut_dout;
		end
	end
	
	assign dut_en = en_r2 & (!fifo_full_r);
	
	//adder #(data_width) dut(.clk(clk), .nrst(nrst), .enable(dut_en), .din_x(rom_dout_1), .din_y(rom_dout_2), .data_out(temp_dut_dout));
	online_fir dut(.clk(clk), .nrst(nrst), .enable(dut_en), .din_x(rom_dout_1), .data_out(temp_dut_dout));


endmodule
