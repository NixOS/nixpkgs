#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs=$glib
. $setenv

tar xvfz $src || exit 1
cd gnet-* || exit 1
LDFLAGS=-s ./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
