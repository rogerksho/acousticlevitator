module uart_rx
	#(parameter CLOCK_TICKS_PER_BIT = 128) // BAUD RATE = 390625
	(
		input clock_in,
		input RX_serial,
		output reg output_RX_done,
		output reg[7:0] output_RX_byte // change output_RX_byte, buffer_RX_byte, bit_index, RX_DATA_BITS if statement
	);

	
	// states
	parameter
		IDLE 				= 2'b00,
		RX_START_BIT 	= 2'b01,
		RX_DATA_BITS 	= 2'b10,
		RX_STOP_BIT 	= 2'b11;
		
	reg[6:0] clock_counter 	= 7'b0;
	reg[2:0] bit_index 		= 0; // max 8 bits
	reg[7:0] buffer_RX_byte = 8'b0;
	
	reg RX_done;
	// state machine
	reg[1:0]	STATE				= 0;
	
	always @(posedge clock_in)	begin
		case (STATE)
		// IDLE
			IDLE: begin
				// reset registers
				RX_done <= 0;
				clock_counter = 7'b0;
				bit_index = 0;
				
				// if serial line pulled low
				if (RX_serial == 1'b0)
					STATE <= RX_START_BIT;
				else
					STATE <= IDLE;
			end
		
		// RX_START_BIT
			RX_START_BIT: begin
				if (clock_counter == (CLOCK_TICKS_PER_BIT/2)-1) begin
					//in middle of start bit
					if (RX_serial == 1'b1) // if line is high, go idle
						STATE <= IDLE;
					else begin
						clock_counter <= 7'b0;
						STATE <= RX_DATA_BITS; 
					end
				end
				else begin
					clock_counter <= clock_counter + 7'b1;
					STATE <= RX_START_BIT;
				end
			end
			
		// RX_DATA_BITS
			RX_DATA_BITS: begin
				if (clock_counter < CLOCK_TICKS_PER_BIT-1) begin
					clock_counter <= clock_counter + 7'b1;
					STATE <= RX_DATA_BITS;
				end
				else begin
					buffer_RX_byte[bit_index] <= RX_serial;
					STATE <= RX_DATA_BITS;
					
					if (bit_index < 7) begin
						clock_counter <= 0;
						bit_index <= bit_index + 3'b1;
						RX_done <= 0;
					end
					else begin
						clock_counter <= 0;
						bit_index <= 0;
						STATE <= RX_STOP_BIT;
					end
				end
			end
			
		// RX_STOP_BIT
			RX_STOP_BIT: begin
				if (clock_counter < CLOCK_TICKS_PER_BIT-1) begin
					output_RX_byte <= buffer_RX_byte; // cannot use non blocking assignment on same clock cycle, possible metastability
					clock_counter <= clock_counter + 7'b1;
					STATE <= RX_STOP_BIT;
					RX_done <= 1;
				end
				else begin
					clock_counter <= 0;
					STATE <= IDLE;
				end
			end
			
		// default
			default:
				STATE <= IDLE;
		endcase
		
		output_RX_done <= RX_done;
	end
endmodule