#! /bin/sh

buildinputs="$getopt"
. $stdenv/setup || exit 1

tar xvfj $src/*.tar.bz2 || exit 1
cd nix-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make check || exit 1
make install || exit 1
