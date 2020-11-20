#!/bin/bash

set -e

TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-$PWD/$(find fomu-toolchain-* -type d -maxdepth 0 2>/dev/null)}"
echo "TOOLCHAIN_PATH: $TOOLCHAIN_PATH"

export PATH=$TOOLCHAIN_PATH/bin:$PATH
export GHDL_PREFIX=$TOOLCHAIN_PATH/lib/ghdl

echo '::group::RISC-V C Example'
(
	set -x
	cd riscv-blink
	make
	file riscv-blink.dfu
)
echo '::endgroup::'

echo '::group::RISC-V Zig Example'
(
	set -x
	cd riscv-zig-blink
	zig build
	file riscv-zig-blink.bin
)
echo '::endgroup::'

echo '::group::Verilog Blink example'
(
	set -x
	cd verilog/blink
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'

echo '::group::Verilog Blink (expanded) example for Hacker board'
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=hacker
	file blink.dfu
)
echo '::endgroup::'

echo '::group::Verilog Blink (expanded) example for PVT board'
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'

echo '::group::VHDL Blink example'
(

	set -x
	cd vhdl/blink
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'

echo '::group::Mixed HDL Blink example'
(

	set -x
	cd mixed-hdl/blink
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'

echo '::group::LiteX example for Hacker'
(
	set -x
	cd litex
	./workshop.py --board=hacker
	file build/gateware/top.dfu
)
echo '::endgroup::'

echo '::group::LiteX example for PVT'
(
	set -x
	cd litex
	./workshop.py --board=pvt
	file build/gateware/top.dfu
)
echo '::endgroup::'

echo '::group::Migen Blink example for PVT board'
(

	set -x
	cd migen
	FOMU_REV=pvt ./blink.py
	file build/top.bin
	rm -rf build
)
echo '::endgroup::'

echo '::group::Migen Blink (expanded) example for PVT board'
(

	set -x
	cd migen
	FOMU_REV=pvt ./blink-expanded.py
	file build/top.bin
	rm -rf build
)
echo '::endgroup::'

echo '::group::Chisel Blink example'
(
	set -x
	cd chisel/blink
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'
