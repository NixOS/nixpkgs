#! /bin/sh -e

image=/tmp/disk.img

linux ubd0="$image" mem=256M \
  eth0=tuntap,tap1 \
  init="/init"
