
# Build for Raspberry Pi Pico W with OpenOCD and Pi Debug Probe
build_pico_w:
	west build -b rpi_pico/rp2040/w -- -DOPENOCD=$$(which openocd)

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

.PHONY: build_pico_w flash uart clean
