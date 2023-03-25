module phase_generator
	#(parameter COUNTS_PER_PERIOD = 128)
	(
		input clock_slow,
		output reg clock_out,
		input wire[6:0] phase_shift,
		input apply_shift
	);
	
	// variables
	reg[6:0] counter = 6'd0;
	reg apply_shift_d1;
	
	initial
		clock_out = 0;
	
	// divided clock (10 MHz)
	always @(posedge clock_slow) begin
		// increment
		counter <= counter + 6'd1;
		
		apply_shift_d1 <= apply_shift;
		
		// apply_shift rising edge detection
		if (!apply_shift_d1 & apply_shift) begin
			counter <= phase_shift;
		end
		
		// output
		clock_out <= (counter < COUNTS_PER_PERIOD/2) ? 1'b1:1'b0;
	end
endmodule