#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs=$glib
. $setenv || exit 1

tar xvfz $src || exit 1
cd gnet-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1

echo $envpkgs > $out/envpkgs || exit 1
