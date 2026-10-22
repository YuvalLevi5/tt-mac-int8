import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge


@cocotb.test()
async def test_mac(dut):
    dut._log.info("Start")

    # 50 MHz clock (only for timing the test; the value is arbitrary here)
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # Reset: accumulator clears to 0 while rst_n is low
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)
    # Sample outputs mid-cycle, safely away from the clock edge
    await FallingEdge(dut.clk)
    assert dut.uo_out.value == 0

    async def push(a, w):
        """Present one operand/weight pair for exactly one clock cycle."""
        dut.ui_in.value = a & 0xFF
        dut.uio_in.value = w & 0xFF
        await ClockCycles(dut.clk, 1)
        await FallingEdge(dut.clk)

    # 3*4 = 12
    await push(3, 4)
    assert dut.uo_out.value == 12

    # 12 + (-2)*5 = 2
    await push(-2, 5)
    assert dut.uo_out.value == 2

    # 2 + 10*10 = 102
    await push(10, 10)
    assert dut.uo_out.value == 102

    # Reset again, then a negative sum: (-3)*4 = -12 -> low byte is 244
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1
    await push(-3, 4)
    assert dut.uo_out.value == 244

    dut._log.info("PASS")
