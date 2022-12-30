# VenusOS in Docker

This is a dockerized [VenusOS](https://github.com/victronenergy/venus) distribution. FYI Venus OS is an OS from Victron Energy for the Raspberry Pi and BeagleBone Black, a part from their own GX Product family of devices.

**Note** that this only contains a subset of the features that you can find in a device running the full Venus operating system. This can be useful if you just want to gather as much data as you can from your Victron devices and dump them into an existing MQTT broker, or to ship them to VRM so you can monitor your system remotely. Note that this project doesn't provide the Victron UI either.

In simplified terms, VenusOS is a group of different services collecting and generating data from various devices and systems, and communicating all together through the system D-Bus. Some of these services are crucial for the correct functioning of the system, but some of them are optional and only needed based on your specific setup. For example if you don't have any VE.Bus device (Multiplus or the likes) you won't need the `mk2-dbus` container.

I've isolated each of those services (at least the most important ones for now) into their own Docker images and run them together with a shared D-Bus. See the example [`docker-compose.yaml` file](docker-compose.yaml).

The Docker images are built using the [Debian Buster packages](https://github.com/victronenergy/venus/wiki/install-venus-packages-on-Debian) that Victron already provides to install these in a Debian OS.

## Services / Docker images

Here's a quick definition of each of the Docker images in this repository.

### dbus

Runs the D-Bus on a socket at `/var/run/dbus/system_bus_socket`. A volume should be mounted at `/var/run/dbus/` and shared with all other containers so they can all access the D-Bus. For obvious reasons this is a crucial service that is needed by all the rest.

### localsettings

Service that collects settings and user preferences and publishes them on the D-Bus. It also stores them in a file in `/data/conf/`. Other services can make changes to these settings via the D-Bus as well. This service needs to be running for any other services to run properly. Source code can be found [here](https://github.com/victronenergy/localsettings).

### dbus-mqtt

Acts as a bridge between the D-Bus and an MQTT broker. Publishes all services registered in the D-Bus to MQTT and viceversa. Source code can be found [here](https://github.com/victronenergy/dbus-mqtt). You need to define the `MQTT_BROKER_HOST` environment variable, and if the broker has authentication, `MQTT_BROKER_USER` & `MQTT_BROKER_PASS` as well.

### dbus-systemcalc-py

Publish PV totals and other system readings on D-Bus, getting info from other D-Bus services. Source code can be found [here](https://github.com/victronenergy/dbus-systemcalc-py).

### vedirect

Collects data from a VE.Direct device and publishes it to the D-Bus. It requires a [VE.Direct to USB cable](https://www.victronenergy.com/accessories/ve-direct-to-usb-interface), mounted as a device in the container. Source code not available.

You can find the USB device path in the Docker host by running `ls -l /dev/serial/by-id/`.

You can run an instance of this container for each VE.Direct USB cable connected to the system. If you run more than one instance, you'll need to set a different instance number for each via the `VEDIRECTDBUSINSTANCE` environment variable, mount the USB device to a different path in each container and set the `VEDIRECTDEV` environment variable to the path you mounted it.

**Important**: always mount the VE.Direct USB device to a path like `/dev/ttyOx`, `/dev/ttySx` or `/dev/ttyUSBx` inside the container, e.g. `/dev/ttyUSB4`. This is because `vedirect` uses the `x` number in the device path to infer the D-Bus instance number for the device, and VRM and other Venus services make some assumptions regarding that number. So if you use another device name for the USB, your device might not be properly recognized. Because of this, even if all `mk2-dbus` and `vedirect` services run in separate containers, make sure to use different mount paths for each USB mounted inside those containers.

### mk2-dbus

Collects data from a VE.Bus device and publishes it to the D-Bus. It requires an [MK3-VE.Bus to USB cable](https://www.victronenergy.com/accessories/interface-mk3-usb), mounted as a device in the container. Source code not available.

You can find the USB device path in the Docker host by running `ls -l /dev/serial/by-id/`.

You can run an instance of this container for each VE.Bus USB cable connected to the system. If you run more than one instance, you'll need to mount the USB device to a different path in each container, and set the `MK3DEV` environment variable to the path you mounted it. This is because the device path inside the container is used to infer the path to a settings file that is stored in the shared `/data` volume.

**Important**: always mount the MK3 USB device to a path like `/dev/ttyOx`, `/dev/ttySx` or `/dev/ttyUSBx` inside the container, e.g. `/dev/ttyS4`. This is because `mk2-dbus` uses the `x` number in the device path to infer the D-Bus instance number for the device, and VRM and other Venus services make some assumptions regarding that number. So if you use another device name for the USB, your device might not be properly recognized. Because of this, even if all `mk2-dbus` and `vedirect` services run in separate containers, make sure to use different mount paths for each USB mounted inside those containers.

### dbus-vebus-to-pvinverter

Useful when you have AC current sensors for a PV inverter, connected to the VE.Bus device. Source code can be found [here](https://github.com/victronenergy/dbus_vebus_to_pvinverter)

### vrmlogger

Collects data from the D-Bus and publishes it to Victron's VRM portal.

You'll need to register your device to VRM using the VRM Portal ID you'll find in the container logs when it starts, it should be a 12-digit hexadecimal number that looks like this `b827eb010101`. Register on the [VRM site](https://vrm.victronenergy.com/), and then [Add a site](https://vrm.victronenergy.com/site/add).

### WIP

These other images are still a work in progress:

- `html5-app`: https://github.com/victronenergy/venus-html5-app
- `allinone`: an image with all services running together

## Examples

Here are some examples of Docker Compose deployments.

### Simple

Simple setup with a single VE.Direct device publishing data to the VRM portal.

```yaml
version: "3.9"
services:
  dbus:
    image: iuri/venus-dbus
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
  localsettings:
    image: iuri/venus-localsettings
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  dbus-systemcalc-py:
    image: iuri/venus-dbus-systemcalc-py
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  vrmlogger:
    image: iuri/venus-vrmlogger
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  vedirect:
    image: iuri/venus-vedirect
    restart: always
    devices:
      - "/dev/serial/by-id/usb-VictronEnergy_BV_VE_Direct_cable_VE3TNY1H-if00-port0:/dev/ttyUSB0"
    environment:
      - "VEDIRECTDEV=ttyUSB0"
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
volumes:
  var_run_dbus:
  data:
```

### Multiple VE.Bus devices

Multiple VE.Bus devices publishing to an external MQTT broker.

```yaml
version: "3.9"
services:
  dbus:
    image: iuri/venus-dbus
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
  localsettings:
    image: iuri/venus-localsettings
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  dbus-systemcalc-py:
    image: iuri/venus-dbus-systemcalc-py
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  dbus-vebus-to-pvinverter:
    image: iuri/venus-dbus-vebus-to-pvinverter
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  mk2-dbus-1:
    image: iuri/venus-mk2-dbus
    restart: always
    devices:
      - "/dev/serial/by-id/usb-VictronEnergy_MK3-USB_Interface_HQ1347GYUGD-if00-port0:/dev/ttyS0"
    environment:
      - "MK3DEV=/dev/ttyS0"
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  mk2-dbus-2:
    image: iuri/venus-mk2-dbus
    restart: always
    devices:
      - "/dev/serial/by-id/usb-VictronEnergy_MK3-USB_Interface_HW2154GTOIT-if00-port1:/dev/ttyS1"
    environment:
      - "MK3DEV=/dev/ttyS1"
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
  dbus-mqtt:
    image: iuri/venus-dbus-mqtt
    restart: always
    volumes:
      - "var_run_dbus:/var/run/dbus"
      - "data:/data"
    environment:
      - "MQTT_BROKER_HOST=mosquitto"
volumes:
  var_run_dbus:
  data:
```
