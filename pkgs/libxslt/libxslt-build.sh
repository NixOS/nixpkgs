#! /bin/sh

. $stdenv/setup || exit 1

envpkgs="$libxml"
. $setenv

tar xvfz $src || exit 1
cd libxslt-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo $envpkgs > $out/envpkgs || exit 1
