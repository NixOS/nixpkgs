#! /bin/sh

buildinputs="$m4"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd bison-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
