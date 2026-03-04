`default_nettype none
`timescale 1ns / 1ps

/* This testbench instantiates the module and runs a self-checking 
   Verilog simulation for all 8 ALU operations.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the ALU module:
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
      .ena    (ena),      
      .clk    (clk),      
      .rst_n  (rst_n)     
  );

  // Generate a dummy clock (just in case the physical synthesizer expects one)
  always #5 clk = ~clk;

  // --- SELF-CHECKING TESTBENCH LOGIC ---
  initial begin
    // 1. Initialize State
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'b0;
    uio_in = 8'b0;

    // 2. Release Reset
    #10 rst_n = 1;
    #10;

    $display("--- STARTING 4-BIT ALU TESTS ---");

    // 3. Test ADD (000): A = 5, B = 3. Expected = 8
    // Note: B is the upper 4 bits, A is the lower 4 bits -> {B, A}
    uio_in[2:0] = 3'b000;
    ui_in = {4'd3, 4'd5}; 
    #10;
    if (uo_out === 8'd8) $display("PASS: ADD (5 + 3 = 8)");
    else $display("FAIL: ADD. Expected 8, Got %d", uo_out);

    // 4. Test SUB (001): A = 10, B = 4. Expected = 6
    uio_in[2:0] = 3'b001;
    ui_in = {4'd4, 4'd10};
    #10;
    if (uo_out === 8'd6) $display("PASS: SUB (10 - 4 = 6)");
    else $display("FAIL: SUB. Expected 6, Got %d", uo_out);

    // 5. Test MUL (010): A = 6, B = 7. Expected = 42
    uio_in[2:0] = 3'b010;
    ui_in = {4'd7, 4'd6};
    #10;
    if (uo_out === 8'd42) $display("PASS: MUL (6 * 7 = 42)");
    else $display("FAIL: MUL. Expected 42, Got %d", uo_out);

    // 6. Test AND (011): A = 1101 (13), B = 1011 (11). Expected = 1001 (9)
    uio_in[2:0] = 3'b011;
    ui_in = {4'b1011, 4'b1101};
    #10;
    if (uo_out === {4'b0000, 4'b1001}) $display("PASS: AND (1101 & 1011 = 1001)");
    else $display("FAIL: AND. Got %b", uo_out);

    // 7. Test OR (100): A = 0100 (4), B = 0010 (2). Expected = 0110 (6)
    uio_in[2:0] = 3'b100;
    ui_in = {4'b0010, 4'b0100};
    #10;
    if (uo_out === {4'b0000, 4'b0110}) $display("PASS: OR (0100 | 0010 = 0110)");
    else $display("FAIL: OR. Got %b", uo_out);

    // 8. Test XOR (101): A = 1111 (15), B = 0101 (5). Expected = 1010 (10)
    uio_in[2:0] = 3'b101;
    ui_in = {4'b0101, 4'b1111};
    #10;
    if (uo_out === {4'b0000, 4'b1010}) $display("PASS: XOR (1111 ^ 0101 = 1010)");
    else $display("FAIL: XOR. Got %b", uo_out);

    // 9. Test Bin2Gray (110): Combined = {B=0011, A=0110} = 8'b0011_0110 (54)
    // Gray Code math: 54 ^ (54 >> 1) = 00110110 ^ 00011011 = 00101101 (45)
    uio_in[2:0] = 3'b110;
    ui_in = {4'b0011, 4'b0110};
    #10;
    if (uo_out === 8'b0010_1101) $display("PASS: Bin2Gray (54 -> 45)");
    else $display("FAIL: Bin2Gray. Got %b", uo_out);

    // 10. Test Gray2Bin (111): Combined Gray = 0010_1101 (45). Expected Bin = 0011_0110 (54)
    uio_in[2:0] = 3'b111;
    ui_in = {4'b0010, 4'b1101}; // Inputting the Gray code from previous test
    #10;
    if (uo_out === 8'b0011_0110) $display("PASS: Gray2Bin (45 -> 54)");
    else $display("FAIL: Gray2Bin. Got %b", uo_out);

    $display("--- ALL TESTS COMPLETED ---");
    
    // Let the simulation run just a tiny bit longer before closing
    #20;
  end

endmodule
