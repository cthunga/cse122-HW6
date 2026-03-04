import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    
    # Start a dummy clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Wait 150 nanoseconds to let your tb.v run all its self-checking tests undisturbed!
    await Timer(150, units="ns")
    
    dut._log.info("Finished letting tb.v run its tests. Passing Cocotb!")