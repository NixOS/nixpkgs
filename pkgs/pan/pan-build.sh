#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs="$gtk $gtkspell $gnet $libxml"
. $setenv

export LDFLAGS=-s

tar xvfj $src || exit 1
cd pan-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
