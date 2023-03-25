`timescale 1ns/1ns

module phase_generator_test(
  output reg clk_tb,
  output reg[6:0] phase_command_in,
  
  output reg apply_shift_command,
  input wire phase_generator_out
  
  );
  
  wire clk_conn;
  
  clock_divider clk_5MHz(
	  .clock_in(clk_tb),
	  .clock_slow(clk_conn)
  );
  
  phase_generator DUT(
	  .clock_slow(clk_conn),
	  .clock_out(phase_generator_out),
	  .phase_shift(phase_command_in),
	  .apply_shift(apply_shift_command)
  );
  
    // 50 MHz clock
  initial begin
    clk_tb <= 0;
    forever begin
      #10 clk_tb = ~clk_tb;
    end
  end
  
  initial begin
  apply_shift_command <= 0;
	phase_command_in <= 7'd15;
	
	#5000 apply_shift_command <= 1;
	#1280 apply_shift_command <= 0;
  end


endmodule