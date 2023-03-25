`timescale 1ns/1ns

module clock_tb();
  reg clk_tb;
  wire divider_out;
  
  // DUT
  clock_divider DUT(
    .clock_in(clock_tb),
    .clock_slow(divider_out)
  );
  
  // clock
  initial begin:
    clk_tb = 0;
    forever begin
      #10 clk_tb = ~clk_tb;
    end
  end
endmodule // clock_tb
