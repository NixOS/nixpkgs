#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd openssl-* || exit 1
LDFLAGS=-Wl,-S ./config --prefix=$out shared || exit 1
make || exit 1
mkdir $out || exit 1
make install || exit 1
