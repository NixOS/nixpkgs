#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1
cd $out || exit 1
tar xvfz $src || exit 1
cd pkgconfig-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
cd $out || exit 1
rm -rf pkgconfig-* || exit 1
