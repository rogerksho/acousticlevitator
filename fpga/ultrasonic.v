module ultrasonic
	#(parameter NUM_CHANNELS = 50)
	(
		input master_clock,
		
		input SPI_sclk,
		input SPI_mosi,
		input SPI_cs,
		
		input rst,
		
		// data done
		output wire SPI_data_done,
		output reg apply_shift_all = 0, 
		
		// output wire transducer_out,
		output wire [NUM_CHANNELS-1:0] transducer_out
	);
	
	
	// divided clock
	wire clock_slow_10MHz;
	wire[7:0] SPI_byte_in;
	
	// phase shift buffer
	reg[NUM_CHANNELS-1:0][6:0] phase_shift_buffer = 0;
	
	// spi data in
	spi_slave spi(
		.clk(clock_slow_10MHz),
		.ss(SPI_cs),
		.mosi(SPI_mosi),
		.sck(SPI_sclk),
		.done(SPI_data_done),
		.dout(SPI_byte_in)
	);
	
	
	// clock divider 5 MHz
	clock_divider clock_divider_10MHz(
		.clock_in(master_clock),
		.clock_slow(clock_slow_10MHz)
	);

	// transducer array
	phase_generator transducers[NUM_CHANNELS-1:0](
	  .clock_slow(clock_slow_10MHz),
	  .clock_out(transducer_out),
	  .phase_shift(phase_shift_buffer),
	  .apply_shift(apply_shift_all)
  );
  
	// transducer ctr
	reg[5:0] transducer_counter = 6'd0; // 0-49 transducers
	
	// ff for domain crossing
	reg SPI_data_done_d1;
	always @(posedge master_clock) begin
		SPI_data_done_d1 <= SPI_data_done;
		if (transducer_counter > 2) begin
			apply_shift_all <= 1'b0;
		end
		
		// data is available
		if (!SPI_data_done_d1 & SPI_data_done) begin // rising edge data
			phase_shift_buffer[transducer_counter] <= SPI_byte_in[6:0];
		end
		else if (SPI_data_done_d1 & !SPI_data_done) begin // falling edge data
			// loop counter
			if (transducer_counter == NUM_CHANNELS-1) begin
				apply_shift_all <= 1'b1;
				transducer_counter <= 6'd0;
			end
			else begin
				transducer_counter <= transducer_counter+6'd1;
			end
		end
		
		if (rst == 1'b1) begin
			transducer_counter <= 0;
			apply_shift_all <= 1'b0;
		end
	end
	
endmodule