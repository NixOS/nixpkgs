#! /bin/sh -e

image=/tmp/disk.img

linux ubd0="$image" mem=256M \
  eth0=tuntap,tap4,,192.168.150.1 \
  init="/init"
