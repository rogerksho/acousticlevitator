`timescale 1ns/1ns

module ultrasonic_test(
  output reg clk_tb,
  output reg MOSI,
  
  //input wire DATA_DONE,
  
  output wire[49:0] transducer_out_test,
  output wire ALL_DONE
  );
  

  
  reg SPI_cs_in = 1'b1;
  
  // 1 MHz clock SPI CLOCK DOMAIN
  reg sck_in = 1'b0;
  
  parameter SCK_DELAY = 2000;

	reg rst_in = 0;
  
  ultrasonic DUT(
		.master_clock(clk_tb),
		.SPI_sclk(sck_in),
		.SPI_mosi(MOSI),
		.SPI_cs(SPI_cs_in),
		.apply_shift_all(ALL_DONE),
		.rst(rst_in),
		
		// transducers
		.transducer_out(transducer_out_test)
	);
  
  
  // 50 MHz clock
  initial begin
    clk_tb <= 0;
    forever begin
      #10 clk_tb = ~clk_tb;
    end
  end
  
  parameter SPI_DELAY = SCK_DELAY*2;
  
	// TASKS //
		 task send_byte68;
		begin
		MOSI <= 1'b0; // MSB
		#(SCK_DELAY/2) sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1; // read last byte
		#SCK_DELAY sck_in <= 0;
		#SCK_DELAY;
		end
  endtask
  
  task send_byte85;
		begin
		MOSI <= 1'b0; // MSB
		#(SCK_DELAY/2) sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1; // read last byte
		#SCK_DELAY sck_in <= 0;
		
		#SCK_DELAY;
		end
  endtask
  
    task send_byte63;
		begin
		MOSI <= 1'b0; // MSB
		#(SCK_DELAY/2) sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b0;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1;
		#SCK_DELAY sck_in <= 0;
		MOSI <= 1'b1;
		
		#SCK_DELAY sck_in <= 1; // read last byte
		#SCK_DELAY sck_in <= 0;
		
		#SCK_DELAY;
		end
  endtask
	//////////
  
  // testing sequence4
  initial begin
  	#3000 SPI_cs_in <= 1'b0; // pull low to begin transaction
	
			send_byte68();
	#2000 send_byte85();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	rst_in = 1;
	#2000 send_byte63();
	rst_in = 0;
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();

	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	// second 50 bytes
	#8000			send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();

	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	#2000 send_byte63();
	
	
	
	#SPI_DELAY SPI_cs_in <= 1'b1;
  end
  
   // send byte task

endmodule