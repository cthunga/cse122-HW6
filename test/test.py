import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Wait for the Verilog tests to run
    await Timer(1, unit="ms") 
    
    # Read the error counter from the Verilog testbench
    errors = int(dut.error_count.value)
    
    # Force Cocotb to crash and fail the GitHub Action if errors exist!
    assert errors == 0, f"Verilog testbench reported {errors} errors!"
    
    dut._log.info("Finished letting tb.v run its tests. Passing Cocotb!")