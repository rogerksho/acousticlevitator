`timescale 1ns/100ps

module clock_divider_test(
  output reg clk_tb,
  output reg rst,
  
  output wire out_clk
  );

  
  
  // DUT
  clock_divider DUT(
    .clock_in(clk_tb),
	 .rst(rst),
    .clock_slow(out_clk)
  );
  
  initial begin
	clk_tb = 1'b0;
  end
  
  // clock
  initial begin
    clk_tb <= 0;
    forever begin
      #10 clk_tb = ~clk_tb;
    end
  end
  
  initial
	begin
	rst =0;
	#20 rst =1;
	#1000 $finish;
	end
  

endmodule // clock_tb
