# windy-sandbox

**WORK IN PROGRESS**

Zephyr experiments


## Make targets

To avoid typing long repetitive commandline arguments, I'm using a Makefile:

| Make Target  | Description                                              |
| ------------ | -------------------------------------------------------- |
| pico\_w      | west build Zephyr Shell for Pi Pico W with openocd and Pi Debug Probe |
| pico\_w\_mp  | west build MicroPython for Pi Pico W with openocd and Pi Debug Probe |
| menuconfig   | west build -t menuconfig                                 |
| flash        | west flash                                               |
| uart         | connect to Pico W uart console with Pi Debug Probe       |
| clean        | remove build directory                                   |


## MicroPython Submodule

The MicroPython build depends on submodules. The first time you clone this
repo, do a

```
git submodule update --init
```

to get the MicroPython submodule.

Also, several config patches are needed to get the MicroPython Zephyr port to
build with Zephyr 4.0...

In vendor/micropython/ports/zephyr/mpconfigport.h:

1. Comment out the `#ifdef CONFIG_THREAD_CUSTOM_DATA` block with an `#if 0`
   to fix a build error

2. To fix the west build error about:
   `relocation truncated to fit: R_ARM_THM_JUMP11 against symbol 'nlr_push_tail'`,
    add a `#define MICROPY_NLR_THUMB_USE_LONG_JUMP (1)`. The problem may be
    happening on Pi Pico W because Cortex M0+ B instruction not wide enough
    and it doesn't have a B.W. Apparently BL works though. See also:
    https://github.com/adafruit/circuitpython/commit/94b4867fbe576b5523b8bbc0090e1c94ddc8ca34

In vendor/micropython/ports/zephyr/prj.conf:

1. Add this stuff to get more debug info if the kernel hard faults:

   ```
   CONFIG_DEBUG_OPTIMIZATIONS=y
   CONFIG_LOG=y
   CONFIG_LOG_PRINTK=y
   CONFIG_THREAD_NAME=y
   ```

2. Set `CONFIG_FPU=n` to fix a Cortex M0+ build error

3. Comment out all the networking stuff to fix a zephyr hard fault

4. Comment out the `CONFIG_MICROPY_VFS_*` lines to avoid build errors


## Zephyr Shell Config

The Zephyr Shell gets more interesting if you turn on Networking, IPv4, DHCP
Client, Network Connection Manager, etc.

These Kconfig options are useful for adding to prj.conf:

```
# Network stack
CONFIG_NETWORKING=y
CONFIG_NET_HOSTNAME_ENABLE=y
CONFIG_NET_IPV6=n
CONFIG_NET_IPV4=y
CONFIG_NET_TCP=y
CONFIG_NET_DHCPV4=y

# Wifi support (some of this is also enabled by wifi shell)
CONFIG_NET_CONNECTION_MANAGER=y
CONFIG_WIFI=y
CONFIG_WIFI_NM=y

# Shell Extras
CONFIG_NET_SHELL=y
CONFIG_NET_L2_WIFI_SHELL=y
CONFIG_NET_MGMT_EVENT_MONITOR=y
CONFIG_NET_MGMT_EVENT_QUEUE_SIZE=10
```


## Zephyr Shell Commands

These Zephyr Shell commands are useful for exploring the Zephyr wifi and
networking:

```
net events on
wifi scan
wifi connect -s "YOUR_SSID" -k 1 -p "YOUR_WPA2_PSK_PASSPHRASE"
net iface
net ipv4
net cm status
net ping 127.0.0.1
net ping 192.168.0.1
net cm down if wlan0
net cm up if wlan0
net iface down 1
net iface up 1
wifi disconnect
net events off
```


## Misc Notes

This is the best Pi Pico W build command that I've come up with so far:
```
west build -p -b rpi_pico/rp2040/w -- -DOPENOCD=$(which openocd)
```

When I use that, cmake sets `OPENOCD:FILEPATH=/usr/bin/openocd` in
`build/CMakeCache.txt`. That version of openocd (from Debian12) can find
`target/rp2040.cfg` in `/usr/share/openocd/scripts` with no trouble.

If I don't specify `-DOPENOCD=...`, then cmake follows the stuff in
`boards/raspberrypi/rpi_pico/board.cmake` which defaults to cmsis-dap for
`RPI_PICO_DEBUG_ADAPTER` but non-helpfully selects the openocd binary to be
`zephyr-sdk-0.17.0/sysroots/x86_64-pokysdk-linux/usr/bin/openocd`. That build
of openocd doesn't know how to find a useable `target/rp2040.cfg`.
