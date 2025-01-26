
PICO_W_BOARD=-b rpi_pico/rp2040/w
PICO_W_EXTRAS=-DOPENOCD=$$(which openocd)
MICROPYTHON_DIR=vendor/micropython/ports/zephyr

# Build Zephyr shell for Raspberry Pi Pico W with OpenOCD and Pi Debug Probe
pico_w:
	west build $(PICO_W_BOARD) -- $(PICO_W_EXTRAS)

# Build MicroPython for Pi Pico W
pico_w_mp:
	west build $(PICO_W_BOARD) $(MICROPYTHON_DIR) -- $(PICO_W_EXTRAS)

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

.PHONY: pico_w pico_w_mp flash uart clean
