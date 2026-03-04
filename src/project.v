/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  //INPUTS
  wire [3:0] a = ui_in[3:0];
  wire [3:0] b = ui_in[7:4];
  wire [2:0] sel = uio_in[2:0];

  wire [7:0] combined = {b, a};

  assign uio_oe = 8'b0000_0000;

  // LOGIC
  reg [7:0] alu_out;
  always @(*) begin
    case (sel)
      3'b000: alu_out = a + b;
      3'b001: alu_out = a - b;
      3'b010: alu_out = a * b;
      3'b011: alu_out = {4'b0000, a & b};
      3'b100: alu_out = {4'b0000, a | b};
      3'b101: alu_out = {4'b0000, a ^ b};
      3'b110: alu_out = combined ^ (combined >> 1);
      3'b111: alu_out = combined ^ (combined >> 1) ^ (combined >> 2) ^ (combined >> 3) ^ (combined >> 4) ^ (combined >> 5) ^ (combined >> 6) ^ (combined >> 7);
      default: alu_out = 8'b00000000;
    endcase
  end

  // OUTPUTS
  assign uo_out = alu_out;

  assign uio_out = 8'b0000_0000;
  wire _unused = &{ena, clk, rst_n, uio_in[7:3], 1'b0};

endmodule
