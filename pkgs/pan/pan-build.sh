#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

export PATH=$pkgconfig/bin:$PATH
envpkgs="$gtk $gtkspell $gnet $libxml"
. $setenv || exit 1

tar xvfj $src || exit 1
cd pan-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
