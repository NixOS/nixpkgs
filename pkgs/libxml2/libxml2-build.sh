#! /bin/sh

export PATH=/bin:/usr/bin

tar xvfz $src || exit 1
cd libxml2-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
