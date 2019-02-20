# debian-container

Create and start a debian container

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
