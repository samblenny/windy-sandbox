# windy-sandbox

**WORK IN PROGRESS**

Zephyr experiments


## Make targets

To avoid typing long repetitive commandline arguments, I'm using a Makefile:

| Make Target    | Description                                              |
| -------------- | -------------------------------------------------------- |
| build\_pico\_w | west build for Pi Pico W with openocd and Pi Debug Probe |
| menuconfig     | west build -t menuconfig                                 |
| flash          | west flash                                               |
| uart           | connect to Pico W uart console with Pi Debug Probe       |
| clean          | remove build directory                                   |


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
