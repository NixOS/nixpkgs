#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs="$gtk $gtkspell $gnet $libxml"
. $setenv

export LDFLAGS=-s

tar xvfj $src
cd pan-*
./configure --prefix=$out
make
make install
echo $envpkgs > $out/envpkgs || exit 1
