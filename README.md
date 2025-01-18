# windy-sandbox

**WORK IN PROGRESS (ALPHA)**

Zephyr experiments


## Misc Notes

This is the best Pi Pico W build command that I've come up with so far:
```
west build -p -b rpi_pico/rp2040/w -- -DOPENOCD=$(which openocd)
```

When I use that, cmake sets `OPENOCD:FILEPATH=/usr/bin/openocd` in
`build/CMakeCache.txt`. That version of openocd (from Debian12) can find
`target/rp2040.cfg` in `/usr/share/openocd/scripts` with no trouble.

If I don't specify `-DOPENOCD=...`, then cmake follows the stuff in
`boards/raspberrypi/rpi_pico/board.cmake` which defaults to cmsiss-dap for
`RPI_PICO_DEBUG_ADAPTER` but non-helpfully selects the openocd binary to be
`zephyr-sdk-0.17.0/sysroots/x86_64-pokysdk-linux/usr/bin/openocd`. That build
of openocd doesn't know how to find a useable `target/rp2040.cfg`.
