#!/usr/bin/env bash

DIST=stretch
DIST_URL=http://deb.debian.org/debian
DIST_ARCH=amd64

DEST=debian-${DIST}
mkdir -p ${DEST}
mkdir -p ${DEST}.tmp

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "debootstrap-ing ...."
debootstrap --foreign --include=ca-certificates,ssh,locales,man-db,manpages --arch=${DIST_ARCH} ${DIST} ${DEST}.tmp ${DIST_URL}

LANG=C LC_ALL=C chroot ${DEST}.tmp /bin/bash -c "/debootstrap/debootstrap --second-stage"
echo "Done debootstrap-ing"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Some cleaning up ..."
rm -f ${DEST}.tmp/etc/hostname
rm -f ${DEST}.tmp/etc/ssh/ssh_host_*
ln -s /proc/mounts ${DEST}.tmp/etc/mtab

echo "rsync ... ${DEST}.tmp/* -> ${DEST}"
rsync --quiet --archive --devices --specials --hard-links --acls --xattrs --sparse ${DEST}.tmp/* ${DEST}
echo "Done !"
cd files/common ; find . -type f ! -name '*~' -exec cp --preserve=mode,timestamps --parents \{\} ../../${DEST} \;
cd ../../
pwd

chmod +x postinstall
cp postinstall ${DEST}

mount -t proc /proc ${DEST}/proc
mount --bind /sys ${DEST}/sys
mount --bind /dev ${DEST}/dev
LANG=C LC_ALL=C chroot ${DEST} /bin/bash -l -c "/postinstall ${DIST} ${DIST_URL}"
rm ${DEST}/postinstall
umount -R -l ${DEST}/dev
umount -R -l ${DEST}/sys
umount ${DEST}/proc
