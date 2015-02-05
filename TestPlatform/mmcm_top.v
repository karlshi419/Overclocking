`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:23:44 01/26/2015 
// Design Name: 
// Module Name:    mmcm_top 
// Additional Comments: 
//		generate clock signal for user ip
//////////////////////////////////////////////////////////////////////////////////
module mmcm_top(clk, RST, wr_en, ram_rd_finish, mmcm_lock, CLK0OUT, mmcm_STATE);

	  // RST will reset the entire reference design including the MMCM_ADV
      input RST;
      
		// clk is the input clock that feeds the MMCM_ADV CLKIN as well as the
      // clock for the MMCM_DRP module
      input clk;
		input wr_en;
		input ram_rd_finish;
		
		output mmcm_lock;
      output mmcm_STATE;
		output CLK0OUT;		

	
	// SSTEP is the input to start a reconfiguration.  It should only be
   // pulsed for one clock cycle.
	reg SSTEP;
	
	// SRDY pulses for one clock cycle after the MMCM_ADV is locked and the 
   // MMCM_DRP module is ready to start another re-configuration
   wire SRDY;
   
	// STATE determines which state the MMCM_ADV will be reconfigured to.  A 
   // value of 0 correlates to state 1, value of 1 correlates to state 2
   // value of 2 correlates to state 3
	reg [1:0] mmcm_STATE;
	reg [1:0] next_mmcm_STATE;
   
   // These signals are used as direct connections between the MMCM_ADV and the
   // MMCM_DRP.
   wire [15:0]    di;
   wire [6:0]     daddr;
   wire [15:0]    dout;
   wire           den;
   wire           dwe;
   wire           dclk;
   wire           rst_mmcm;
   wire           drdy;
   wire           locked;
   
	assign mmcm_lock = locked;
	//signals for MMCM-adv
	wire PWRDWN = 1'b0;
	
	wire CLKFBOUT_bufin, CLKFBOUT_bufout;
	wire CLKIN1;
	wire CLKFBIN1;
	wire CLKFBOUT1;
	
   // These signals are used for the BUFG's necessary for the design.
   
   wire           clk0_bufgin;
   wire           clk0_bufgout;
	
	//-- Configuration Parameters ----//
	 localparam CLKIN1_PERIOD		= 5.000;		// Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
	 
	 localparam DIVCLK_DIVIDE 		= 1;
	 localparam CLKFBOUT_MULT_F 	= 5;
	 
	 
	 localparam CLKOUT0_DIVIDE_F 	= 5.0;	// real
	 
	// State Configuration Parameters 
	localparam S1_CLKFBOUT_MULT	= 5;
	localparam S1_DIVCLK_DIVIDE	= 1;
   localparam S1_CLKOUT0_DIVIDE	= 5;
	
	localparam S2_CLKFBOUT_MULT	= 5;
	localparam S2_DIVCLK_DIVIDE	= 1;
   localparam S2_CLKOUT0_DIVIDE	= 4;
	
	localparam S3_CLKFBOUT_MULT	= 3;
	localparam S3_DIVCLK_DIVIDE	= 1;
   localparam S3_CLKOUT0_DIVIDE	= 2;
	  
	//---- Global buffers used in design ----//
   
	// MMCM_ADV Buffers
	BUFG bufg_clkfbout(			//feedback clock buffer
		.I(CLKFBOUT_bufin),
		.O(CLKFBOUT_bufout)
	);

	//-- Output Clock Buffers of ADV --//
	BUFG bufg_clkout0(
		.I(clk0_bufgin),
		//.O(clk0_bufgout)
		.O(CLK0OUT)
	);
      
   // MMCM_ADV that reconfiguration will take place on
   MMCM_ADV #(
      // "HIGH", "LOW" or "OPTIMIZED"
      .BANDWIDTH("OPTIMIZED"), 
		//---- Divide ----//
      .DIVCLK_DIVIDE(DIVCLK_DIVIDE), // (1 to 52)
      //---- Multiply ---//
      .CLKFBOUT_MULT_F(CLKFBOUT_MULT_F), 
      .CLKFBOUT_PHASE(0.0),
      .CLKFBOUT_USE_FINE_PS("FALSE"),
      // Set the clock period (ns) of input clocks
      .CLKIN1_PERIOD(CLKIN1_PERIOD), 
      .REF_JITTER1(0.010),
      .CLKIN2_PERIOD(CLKIN1_PERIOD),
      .REF_JITTER2(0.010),
      // CLKOUT parameters:
      // DIVIDE: (1 to 128)
      // DUTY_CYCLE: (0.01 to 0.99) - This is dependent on the divide value.
      // PHASE: (0.0 to 360.0) - This is dependent on the divide value.
      // USE_FINE_PS: (TRUE or FALSE)
      .CLKOUT0_DIVIDE_F(CLKOUT0_DIVIDE_F), 
      .CLKOUT0_DUTY_CYCLE(0.5), 
      .CLKOUT0_PHASE(0.0), 
      .CLKOUT0_USE_FINE_PS("FALSE"),

      .CLKOUT1_DIVIDE(1), 
      .CLKOUT1_DUTY_CYCLE(0.5), 
      .CLKOUT1_PHASE(0.0),
      .CLKOUT1_USE_FINE_PS("FALSE"),    

      .CLKOUT2_DIVIDE(1), 
      .CLKOUT2_DUTY_CYCLE(0.5), 
      .CLKOUT2_PHASE(0.0), 
      .CLKOUT2_USE_FINE_PS("FALSE"),

      .CLKOUT3_DIVIDE(1), 
      .CLKOUT3_DUTY_CYCLE(0.5), 
      .CLKOUT3_PHASE(0.0), 
      .CLKOUT3_USE_FINE_PS("FALSE"),

      .CLKOUT4_DIVIDE(1), 
      .CLKOUT4_DUTY_CYCLE(0.5), 
      .CLKOUT4_PHASE(0.0), 
      .CLKOUT4_USE_FINE_PS("FALSE"),
      .CLKOUT4_CASCADE("FALSE"),

      .CLKOUT5_DIVIDE(1), 
      .CLKOUT5_DUTY_CYCLE(0.5), 
      .CLKOUT5_PHASE(0.0),
      .CLKOUT5_USE_FINE_PS("FALSE"),      
      
      .CLKOUT6_DIVIDE(1), 
      .CLKOUT6_DUTY_CYCLE(0.5), 
      .CLKOUT6_PHASE(0.0), 
      .CLKOUT6_USE_FINE_PS("FALSE"),
      
      // Misc parameters
      .CLOCK_HOLD("FALSE"),
      .COMPENSATION("ZHOLD"),
      .STARTUP_WAIT("FALSE")
   ) mmcm_adv_inst (
      .CLKFBOUT(CLKFBOUT_bufin),
      .CLKFBOUTB(),
      
      .CLKFBSTOPPED(),
      .CLKINSTOPPED(),

      // Clock outputs
      .CLKOUT0(clk0_bufgin), 
      .CLKOUT0B(),
      .CLKOUT1(),
      .CLKOUT1B(),
      .CLKOUT2(),
      .CLKOUT2B(),
      .CLKOUT3(),
      .CLKOUT3B(),
      .CLKOUT4(), 
      .CLKOUT5(), 
      .CLKOUT6(),

      // DRP Ports
      .DO(dout), // (16-bits)
      .DRDY(drdy), 
      .DADDR(daddr), // 5 bits
      .DCLK(dclk), 
      .DEN(den), 
      .DI(di), // 16 bits
      .DWE(dwe), 

      .LOCKED(locked), 
      .CLKFBIN(CLKFBOUT_bufout), 

      // Clock inputs
		.CLKIN1(clk),
      .CLKIN2(),
      .CLKINSEL(1'b1), 

      // Fine phase shifting
      .PSDONE(),
      .PSCLK(1'b0),
      .PSEN(1'b0),
      .PSINCDEC(1'b0),
 
      .PWRDWN(1'b0),
      .RST(rst_mmcm)
   );
   
   // MMCM_DRP instance that will perform the reconfiguration operations
   mmcm_drp #(
      //***********************************************************************
      // State 1 Parameters - These are for the first reconfiguration state.
      //***********************************************************************
      // Set the multiply to 5 with 0 deg phase offset, low bandwidth, input
      // divide of 1
      .S1_CLKFBOUT_MULT(S1_CLKFBOUT_MULT),
      .S1_CLKFBOUT_PHASE(0),
      .S1_BANDWIDTH("LOW"),
      .S1_DIVCLK_DIVIDE(S1_DIVCLK_DIVIDE),
      
      // Set clock out 0 to a divide of 5, 0deg phase offset, 50/50 duty cycle
      .S1_CLKOUT0_DIVIDE(S1_CLKOUT0_DIVIDE),
      .S1_CLKOUT0_PHASE(0),
      .S1_CLKOUT0_DUTY(50000),
      
      //***********************************************************************
      // State 2 Parameters - These are for the second reconfiguration state.
      //***********************************************************************
      .S2_CLKFBOUT_MULT(S2_CLKFBOUT_MULT),
      .S2_CLKFBOUT_PHASE(0),
      .S2_BANDWIDTH("LOW"),
      .S2_DIVCLK_DIVIDE(S2_DIVCLK_DIVIDE),

      // Set clock out 0 to a divide of 8, 0deg phase offset, 50/50 duty cycle
      .S2_CLKOUT0_DIVIDE(S2_CLKOUT0_DIVIDE),
      .S2_CLKOUT0_PHASE(0),
      .S2_CLKOUT0_DUTY(50000),
		
		//***********************************************************************
      // State 3 Parameters - These are for the second reconfiguration state.
      //***********************************************************************
      .S3_CLKFBOUT_MULT(S3_CLKFBOUT_MULT),
      .S3_CLKFBOUT_PHASE(0),
      .S3_BANDWIDTH("LOW"),
      .S3_DIVCLK_DIVIDE(S3_DIVCLK_DIVIDE),

      .S3_CLKOUT0_DIVIDE(S3_CLKOUT0_DIVIDE),
      .S3_CLKOUT0_PHASE(0),
      .S3_CLKOUT0_DUTY(50000)
      

   ) mmcm_drp_inst (
      // Top port connections
      .SADDR(mmcm_STATE),
      .SEN(SSTEP),
      .RST(RST),
      .SRDY(SRDY),
      
      // Input from IBUFG
      .SCLK(clk),
      
      // Direct connections to the MMCM_ADV
      .DO(dout),
      .DRDY(drdy),
      .LOCKED(locked),
      .DWE(dwe),
      .DEN(den),
      .DADDR(daddr),
      .DI(di),
      .DCLK(dclk),
      .RST_MMCM(rst_mmcm)
   );
	
	//---- MMCM Control FSM Signals ----//
	reg [1:0] current_state, next_state;
	
	localparam [1:0] init_state	= 2'b00;
	localparam [1:0] setup_state	= 2'b01;
	localparam [1:0] config_state	= 2'b11;
	localparam [1:0] stable_state	= 2'b10;
	
	//---- FSM for MMCM Dynamic Configuration ----//
	
	always @(posedge clk) begin
		if(RST) begin
			current_state 	<= init_state;
			mmcm_STATE		<= 0;
		end
		else begin
			current_state	<= next_state;
			mmcm_STATE		<= next_mmcm_STATE;
		end
	end
	
	always @(*) begin
		next_state = current_state;
		case(current_state)
			init_state: 
				if(SRDY | wr_en)	next_state = setup_state;
			
			setup_state: begin
				if(wr_en) next_state = config_state;
			end
			
			config_state: 
				if(SRDY) next_state = stable_state;
			
			stable_state: begin
				if(ram_rd_finish) 	next_state = setup_state;
				else if(!wr_en) 	next_state = init_state;
			end
			
			default: next_state = init_state;
		endcase
	end
	
	// logic of each state
	always @ (*) begin
		SSTEP = 0;
		//mmcm_STATE = 0;
		next_mmcm_STATE = mmcm_STATE;
		
		case(current_state) 
			init_state:;
			setup_state: 
				if(wr_en) SSTEP = 1;
			config_state:;
			stable_state: begin
				if(ram_rd_finish) 	next_mmcm_STATE = mmcm_STATE + 1;
				else if(!wr_en)	next_mmcm_STATE = 0;
			end
		endcase	
	end

endmodule
