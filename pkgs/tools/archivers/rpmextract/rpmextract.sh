#!/bin/sh

if [ "$1" = "" ]; then
  echo "usage: rpmextract package_name" 1>&2
  exit 1
fi

@rpm@/bin/rpm2cpio "$1" | @cpio@/bin/cpio -idv
