#! /bin/sh

buildinputs="$perl $python"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd SWIG-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
