## What it does

An INT8 multiply-accumulate (MAC) unit — the basic building block of a neural-network accelerator. Every clock cycle it multiplies the two signed 8-bit inputs and adds the product to a 32-bit accumulator:

acc = acc + a * w

## How it works

- `ui_in` carries the operand `a` (for example an activation), `uio_in` carries the weight `w`.
- On each rising clock edge the product `a * w` is added to the accumulator.
- `uo_out` shows the low 8 bits of the accumulator.
- Pull `rst_n` low to clear the accumulator to zero.

## How to test

Reset the design, then feed operand/weight pairs, one pair per clock cycle, and watch the low byte of the running sum on the outputs. Example sequence: (3, 4), (-2, 5), (10, 10) gives products 12, -10, 100, so the accumulator ends at 102.
