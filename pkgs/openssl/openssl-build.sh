#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

envpkgs=""
. $setenv || exit 1

tar xvfz $src || exit 1
cd openssl-* || exit 1
./config --prefix=$out shared || exit 1
make || exit 1
mkdir $out || exit 1
make install || exit 1

echo $envpkgs > $out/envpkgs || exit 1
