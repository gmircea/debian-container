# debian-container

Create and start a debian container

## Quickstart

To build the container:

```
# ./build.sh
```

To start/boot the container:

```
# systemd-nspawn -b -D debian-stretch
```

To chroot:

```
# systemd-nspawn -D debian-stretch
```
## Access usb device from systemd-nspawn container

see: https://unix.stackexchange.com/questions/304252/access-usb-device-from-systemd-nspawn-container
