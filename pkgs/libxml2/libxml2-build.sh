#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd libxml2-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
