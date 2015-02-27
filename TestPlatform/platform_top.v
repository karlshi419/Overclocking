`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:17:45 01/25/2015 
// Design Name: 
// Module Name:    platform_top 
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
//			Add MMCM Dynamic Configuration
//////////////////////////////////////////////////////////////////////////////////
//module platform_top(sys_clk, sys_rst, read_enable, write_enable, led);
module platform_top(sys_clk_p, sys_clk_n, sys_rst, led);

parameter AddrWL = 11;
//parameter data_width_out = 40;	//fir
//parameter data_width_out = 24;	//sobel
//parameter data_width_out = 16;	//iir
//parameter data_width_out = 26;	//dct
//parameter data_width_out = 44;	//taylor_log_full
parameter data_width_out = 18;	//taylor_log_full

	input sys_clk_p,sys_clk_n;
	
	input sys_rst;

	//test
	/*input sys_clk;
	input write_enable;
	input read_enable;
	*/
	output [7:0] led;
	
	wire dut_en;
	wire [data_width_out-1:0] dut_dout;
	
	wire write_enable, read_enable;
	
	//---- Clock signals ----//
	wire clk;		//200MHz

	
	wire clk_ip_oddr_in;
	wire clk_ip;
	
	//-- MMCM Signals --//
	wire mmcm_lock;
	wire [4:0] mmcm_STATE;
	
	wire nrst;
	wire nrst_bufg;

	assign nrst_bufg = ~sys_rst;	//Pin(G26) on SW9 (SW_Central pushbutton)
	
	BUFG bufg_nrst
		(
		 .O (nrst),
       .I (nrst_bufg)
      );
		
	//---- FIFO signals ----//
	wire fifo_empty;		//from fifo
	wire fifo_full;		//from fifo
	wire fifo_wr_en;		//to fifo
	wire fifo_rd_en;
	
	wire [data_width_out-1:0] fifo_dout;
	wire fifo_clear;
	
	//---- BRAM signals ----//
	wire bram_write_en;
	wire bram_read_en;
	
	wire bram_read_finish;
	
	wire [AddrWL-1:0] bram_address_write;
	wire [AddrWL-1:0] bram_address_read;
	
	wire [data_width_out-1:0] bram_dout;
	
	//---- Clock Generation ----//
	ml605_clkgen clkgen(.sys_clk_p(sys_clk_p), .sys_clk_n(sys_clk_n), .clk_200(clk));
	//assign clk = sys_clk;	//for test

	
	//-- Generate IP Clock --//
	(* KEEP_HIERARCHY="true" *)
	mmcm_top sys_mmcm(.clk(clk), .RST(sys_rst), .wr_en(write_enable), .ram_rd_finish(bram_read_finish), 
							.mmcm_lock(mmcm_lock), .CLK0OUT(clk_ip), .mmcm_STATE(mmcm_STATE));
							
	//---- Control Block ----//
	(* KEEP_HIERARCHY="true" *)
	control #(AddrWL) control_logic(.clk(clk), .nrst(nrst), .write_enable(write_enable), .read_enable(read_enable), 
								 .dut_en(dut_en), .mmcm_lock(mmcm_lock),
								 .fifo_empty(fifo_empty), .fifo_read_en(fifo_rd_en), .fifo_clear(fifo_clear),
								 .bram_write_en(bram_write_en), .bram_read_en(bram_read_en),  .bram_read_finish(bram_read_finish),
								 .bram_address_write(bram_address_write), .bram_address_read(bram_address_read));
	
	//---- Design Under Test ----//
	(* KEEP_HIERARCHY="true" *)
	dut_top #(.rom_depth_bits(AddrWL))
			  design_top(.clk(clk_ip), .nrst(nrst), 
							 .enable(dut_en), 			//input dut enable
							 .fifo_full(fifo_full), 	//input fifo full
							 .fifo_wr_en(fifo_wr_en), 	//output, sync to clk_ip, fifo_wr_en
							 .dut_dout(dut_dout));
	
	//---- Async FIFO ----//
	fifo async_fifo(
		.rst(fifo_clear), // input rst
		.wr_clk(clk_ip), // input wr_clk
		.rd_clk(clk), // input rd_clk
		.din(dut_dout), // input [data_width_out-1 : 0] din
		.wr_en(fifo_wr_en), // input wr_en
		.rd_en(fifo_rd_en), // input rd_en
		.dout(fifo_dout), // output [data_width_out-1 : 0] dout
		.full(fifo_full), // output full
		.empty(fifo_empty) // output empty
	);
	
	//---- BRAM output ----//
	ram_out sys_ram_out (
		.clka(clk), // input clka
		.wea(bram_write_en), // input [0 : 0] wea
		.addra(bram_address_write), // input [AddrWL-1 : 0] addra
		.dina(fifo_dout), // input [data_width_out-1 : 0] dina
		.clkb(clk), // input clkb
		.rstb(!bram_read_en), // input rstb
		.enb(bram_read_en), // input enb
		.addrb(bram_address_read), // input [AddrWL-1 : 0] addrb
		.doutb(bram_dout) // output [7 : 0] doutb
	);
	
	//---- ChipScope Modules ----//	
	localparam ila_data_width = data_width_out+6;
	
	wire [1:0] 	vio_out;
	wire [ila_data_width-1:0] ila_data;
	wire [7:0]	trig0;
	
	chipscope #(ila_data_width)cs(.clk(clk), .ila_data(ila_data), .trig0(trig0), .vio_out(vio_out));
	
	//-- ILA data signal connections --//
	assign ila_data[ila_data_width-7:0]							= bram_dout;
	assign ila_data[ila_data_width-2:ila_data_width-6]		= mmcm_STATE;
	assign ila_data[ila_data_width-1]							= bram_read_en;

	
	
	//-- ILA trigger signal connections --//
	assign trig0[0] 	= bram_read_en;
	assign trig0[7:1]	= 7'b0;
	
	//-- VIO signal connections --//
	assign write_enable	= vio_out[1];
	assign read_enable	= vio_out[0];
	
	assign led[2:0] = bram_dout[7:4];
	assign led[7:3] = mmcm_STATE;


endmodule
