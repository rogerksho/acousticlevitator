`timescale 1ns/100ps

module uart_test(
  output reg clk_tb,
  output reg SERIAL_IN,
  
  output wire[7:0] out_data,
  input wire DATA_DONE
  );
  
  initial begin
	SERIAL_IN = 1'b1;
  end
  
  uart_rx DUT(
	.clock_in(clk_tb),
	.RX_serial(SERIAL_IN),
	.output_RX_done(DATA_DONE),
	.output_RX_byte(out_data)
  );
  
  // 50 MHz clock
  initial begin
    clk_tb <= 0;
    forever begin
      #10 clk_tb = ~clk_tb;
    end
  end
  
  // begin transmission signal
  initial begin
	#50 SERIAL_IN <= 1'b0;
	
	#2560 SERIAL_IN <= 1'b1; // LSB
	#2560 SERIAL_IN <= 1'b0;
	#2560 SERIAL_IN <= 1'b1;
	#2560 SERIAL_IN <= 1'b0;
	#2560 SERIAL_IN <= 1'b1;
	#2560 SERIAL_IN <= 1'b1;
	#2560 SERIAL_IN <= 1'b1;
	#2560 SERIAL_IN <= 1'b1; // MSB
	
	#2560 SERIAL_IN <= 1'b1;
	#100000 $finish;
	end
  
	// BAUD RATE = 390625
	// 2.56 us = 2560 ns between each edge
endmodule