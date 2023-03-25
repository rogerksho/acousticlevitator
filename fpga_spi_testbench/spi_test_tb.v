`timescale 1ns/100ps

module spi_test_TB();

	// input
	reg clk_std = 1'b0;
	reg sck_in = 1'b0;
	reg rst_in = 1'b0;
	reg ss_in = 1'b1;
	
	reg SPI_mosi;
	wire SPI_miso;
	
	wire transfer_done;
	
	wire[7:0] transferred_byte;
	
	// clock generator
	always #(50) sck_in = ~sck_in; // 10 MHz clock SPI CLOCK DOMAIN
	always #(10) clk_std = ~clk_std; // 50 MHz clock FPGA CLOCK DOMAIN
	
	// dut
	spi_test SPI_DUT(
		.clk(clk_std),
		.rst(rst_in),
		.ss(ss_in),
		.mosi(SPI_mosi),
		.miso(SPI_miso),
		.sck(sck_in),
		.done(transfer_done),
		.dout(transferred_byte)
	);
	
	// test
	initial begin
		rst_in = 1;
		#500 rst_in = 0;
		#1000 ss_in = 0; // pull chip select low
		
			  SPI_mosi = 0;
		#100 SPI_mosi = 0;
		#100 SPI_mosi = 0;
		#100 SPI_mosi = 1;
		
		#100 SPI_mosi = 1;
		#100 SPI_mosi = 0;
		#100 SPI_mosi = 0;
		#100 SPI_mosi = 0;
		
		#100 SPI_mosi = 0;
		#5 ss_in = 1;
	end
	
	

endmodule