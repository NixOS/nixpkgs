#! /bin/sh

export PATH=/bin:/usr/bin

tar xvfz $src || exit 1
cd pkgconfig-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
mkdir $out || exit 1
make install || exit 1
