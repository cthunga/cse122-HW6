<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an 8-operation, 4-bit ALU. 

The ALU takes two 4-bit operands and a 3-bit opcode as input. ALU outputs a 8-bit output.

**I/O Mapping:**
* `ui_in[3:0]`: 4-bit Operand A
* `ui_in[7:4]`: 4-bit Operand B
* `uio_in[2:0]`: 3-bit Operation Selector
* `uo_out[7:0]`: 8-bit Result Output

**Opcodes:**
* `000`: Addition (A + B)
* `001`: Subtraction (A - B)
* `010`: Multiplication (A * B)
* `011`: Bitwise AND
* `100`: Bitwise OR
* `101`: Bitwise XOR
* `110`: 8-bit Binary to Gray Code Conversion 
* `111`: 8-bit Gray Code to Binary Conversion

**Operations**
* Addition: Takes two 4-bit inputs and returns a 8-bit output. The left 3 bits of the output are 0 and the right 5 bits are the result.
* Subtraction: Takes two 4-bit inputs and returns a 8-bit output. The left 3 bits of the output are 0 and the right 5 bits are the result (Note: if B > A, the output will wrap around into 8-bit Two's Complement).
* Multiplication: Takes two 4-bit inputs and returns an 8-bit result as the output.
* Bitwise AND: Takes two 4-bit inputs and returns an 8-bit output. The left 4 bits are 0 and the right 4 bits contain the bitwise AND result.
* Bitwise OR: Takes two 4-bit inputs and returns an 8-bit output. The left 4 bits are 0 and the right 4 bits contain the bitwise OR result.
* Bitwise XOR: Takes two 4-bit inputs and returns an 8-bit output. The left 4 bits are 0 and the right 4 bits contain the bitwise XOR result.
* Binary to Gray Code: Concatenates the two 4-bit inputs into a single 8-bit binary word (Operand B as the upper 4 bits, Operand A as the lower 4 bits) and returns its 8-bit Gray code equivalent.
* Gray to Binary Code: Concatenates the two 4-bit inputs into a single 8-bit Gray code word (Operand B as the upper 4 bits, Operand A as the lower 4 bits) and returns its 8-bit standard binary equivalent.

## How to test

The design is verified using a self-checking Verilog testbench. 

This testbench is sufficient to test the design because it systematically iterates through all 8 operational opcodes, applying various combinations of Operands A and B (including edge cases like maximum 4-bit values for multiplication and subtraction underflow). The testbench independently calculates the expected 8-bit result and asserts it against the module's actual `uo_out` signal, immediately flagging any logical mismatches or synthesis truncation errors.

## External hardware

No external hardware is required. However, to test the ALU, you would need 11 switches for inputs and 8 LEDs to display the result.