#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

mkdir -p obj
export MAKEOBJDIRPREFIX="$(realpath obj)"
tar -zxvf $src
cd $dname

make world DESTDIR=$out -j $NIX_BUILD_CORES -DNO_ROOT
