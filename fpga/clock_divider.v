// SPLITS 50 MHz CLOCK INTO 10 MHz
module clock_divider
	#(parameter DIVISOR = 4'd5)
	(
		input clock_in,
		output reg clock_slow
	);
	
	// master clock = 50 MHz / 5 = 10 MHz
	// using a 7 bit counter, 2^7 = 128, (10e6/2)/128 = 39062.5 Hz
	
	reg[3:0] counter = 4'd0;
	
	initial
		clock_slow = 1'b0;
	
	// 50 MHz
	always @(posedge clock_in) begin
		counter <= counter + 4'd1;
		
		if (counter >= (DIVISOR-1)) begin
			counter <= 4'd0;
			clock_slow <= ~clock_slow;
		end
	end
endmodule