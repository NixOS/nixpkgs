#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

export PATH=$pkgconfig/bin:$PATH

tar xvfj $src || exit 1
cd glib-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
