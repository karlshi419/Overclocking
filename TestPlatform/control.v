`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:19:06 01/25/2015 
// Design Name: 
// Module Name:    control 
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
module control(clk, nrst, write_enable, read_enable, dut_en, mmcm_lock,
					fifo_empty, fifo_read_en, fifo_clear,
					bram_write_en, bram_read_en, bram_read_finish,
					bram_address_write, bram_address_read);

parameter AddrWL = 9;
	
	input clk, nrst;
	input write_enable;
	input read_enable;
	output reg dut_en;
	
	input mmcm_lock;	
	
	input fifo_empty;
	output reg fifo_read_en;
	output reg fifo_clear;
	
	output reg bram_write_en;
	output reg bram_read_en;
	
	output reg bram_read_finish;
	
	output reg [AddrWL-1:0] bram_address_write;
	output reg [AddrWL-1:0] bram_address_read;
	
	reg [AddrWL-1:0] next_bram_addr_write;
	reg [AddrWL-1:0] next_bram_addr_read;
	
	localparam [1:0] write_setup_state 	= 2'b00;
	localparam [1:0] write_state 			= 2'b01;
	localparam [1:0] read_setup_state 	= 2'b11;
	localparam [1:0] read_state 			= 2'b10;
	
	reg [1:0] current_state, next_state;
	
	always @ (posedge clk) begin
		if (!nrst) begin
			current_state 			<= write_setup_state;
			bram_address_write 	<= 0;
			bram_address_read		<= 0;
		end
		else begin
			current_state 			<= next_state;
			bram_address_write 	<= next_bram_addr_write;
			bram_address_read		<= next_bram_addr_read;
		end
	end

	// state transition
	always @(*) begin
		next_state = current_state;
		case(current_state)
	
			write_setup_state: begin
				if(write_enable & fifo_empty & mmcm_lock)	next_state = write_state;
			end
			
			write_state: begin
				if(&bram_address_write) next_state = read_setup_state;
			end
			
			read_setup_state: begin
				if(read_enable) 			next_state = read_state;
			end
			
			read_state: begin
				if(&bram_address_read) 	next_state = write_setup_state; 
			end
		endcase
	end
	
	// logic of each state
	always @ (*) begin
		next_bram_addr_read 	= bram_address_read;
		next_bram_addr_write	= bram_address_write;
		dut_en					= 0;
		bram_write_en			= 0;
		bram_read_en			= 0;
		fifo_read_en			= 0;
		fifo_clear				= 0;
		
		bram_read_finish		= 0;
		
		case(current_state)
			write_setup_state: begin
				next_bram_addr_write = 0;
				fifo_clear				= 1;
			end
			
			write_state: begin
				dut_en = 1;
				if (!fifo_empty) begin
					fifo_read_en   = 1;
					bram_write_en 	= 1;
					if (!(&next_bram_addr_write)) next_bram_addr_write = bram_address_write + 1;
				end
			end
			
			read_setup_state: begin
				next_bram_addr_read = 0;
			end
			
			read_state: begin
				bram_read_en = 1;
				if (!(&next_bram_addr_read)) next_bram_addr_read = bram_address_read + 1;
				if (&next_bram_addr_read) bram_read_finish = 1;
			end
			
		endcase
	end

endmodule
