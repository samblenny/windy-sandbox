# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: Copyright 2025 Sam Blenny

# For docs about different ways to specify out-of-tree boards directory:
# https://docs.zephyrproject.org/latest/develop/application/index.html#boards

_BOARD=-b feather_rp2350/rp2350a/m33
_EXTRAS=-DOPENOCD=$$(which openocd) -DBOARD_ROOT=../..

# Build Zephyr shell for Feather RP2350 with OpenOCD and Pi Debug Probe
shell:
	west build $(_BOARD) -- $(_EXTRAS)

menuconfig:
	west build -t menuconfig

# Flash previously built firmware
flash:
	west flash

# Connect to board's serial console using Pi Debug Probe UART interface
uart:
	@screen -fn /dev/serial/by-id/*Pi_Debug* 115200


clean:
	rm -rf build

.PHONY: shell menuconfig flash uart clean
