`default_nettype none
`timescale 1ns / 1ps


module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // Wire up the inputs and outputs:
  //reg clk;
  //reg rst_n;
  //reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  //DUT
  tt_um_example user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),    
      .uo_out (uo_out),   
      .uio_in (uio_in),   
      .uio_out(uio_out),  
      .uio_oe (uio_oe),   
      .ena    (1'b1),      
      .clk    (1'b0),      
      .rst_n  (1'b0)     
  );
  

  // --- SELF-CHECKING TESTBENCH LOGIC ---
    integer i;
    integer error_count = 0;
    reg [3:0] rand_a;
    reg [3:0] rand_b;
    reg [7:0] combined_in;
    reg [7:0] exp_out;

  initial begin
    // 1. Initialize State
    $display("Initializing");
    #20;

    $display("--- STARTING RANDOMIZED TESTS ---");
    for (i = 0; i < 16; i = i + 1) begin
      // Generate random 4-bit inputs
      rand_a = $random & 4'b1111;
      rand_b = $random & 4'b1111;
      combined_in = {rand_b, rand_a};

      $display("Random Iteration %0d (A=%0d, B=%0d)", i+1, rand_a, rand_b);

      // Random ADD
      uio_in[2:0] = 3'b000;
      ui_in = combined_in;
      exp_out = rand_a + rand_b;
      #10;
      if (uo_out === exp_out) $display("PASS: Random ADD");
      else begin
        $display("FAIL: Random ADD. Expected %d, Got %d", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random SUB
      uio_in[2:0] = 3'b001;
      exp_out = rand_a - rand_b; // 8-bit reg handles the Two's Complement wrap automatically!
      #10;
      if (uo_out === exp_out) $display("PASS: Random SUB");
      else begin
        $display("FAIL: Random SUB. Expected %d, Got %d", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random MUL
      uio_in[2:0] = 3'b010;
      exp_out = rand_a * rand_b;
      #10;
      if (uo_out === exp_out) $display("PASS: Random MUL");
      else begin
        $display("FAIL: Random MUL. Expected %d, Got %d", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random AND
      uio_in[2:0] = 3'b011;
      exp_out = {4'b0000, rand_a & rand_b};
      #10;
      if (uo_out === exp_out) $display("PASS: Random AND");
      else begin
        $display("FAIL: Random AND. Expected %b, Got %b", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random OR
      uio_in[2:0] = 3'b100;
      exp_out = {4'b0000, rand_a | rand_b};
      #10;
      if (uo_out === exp_out) $display("PASS: Random OR");
      else begin
        $display("FAIL: Random OR. Expected %b, Got %b", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random XOR
      uio_in[2:0] = 3'b101;
      exp_out = {4'b0000, rand_a ^ rand_b};
      #10;
      if (uo_out === exp_out) $display("PASS: Random XOR");
      else begin
        $display("FAIL: Random XOR. Expected %b, Got %b", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random Bin2Gray
      uio_in[2:0] = 3'b110;
      exp_out = combined_in ^ (combined_in >> 1);
      #10;
      if (uo_out === exp_out) $display("PASS: Random Bin2Gray");
      else begin
        $display("FAIL: Random Bin2Gray. Expected %b, Got %b", exp_out, uo_out);
        error_count = error_count + 1;
      end

      // Random Gray2Bin
      // We take the expected Gray code from the previous step to test the reversal!
      uio_in[2:0] = 3'b111;
      ui_in = exp_out; 
      #10;
      if (uo_out === combined_in) $display("PASS: Random Gray2Bin");
      else begin
        $display("FAIL: Random Gray2Bin. Expected %b, Got %b", combined_in, uo_out);
        error_count = error_count + 1;
      end
      
    end
    #20;
  end

endmodule
