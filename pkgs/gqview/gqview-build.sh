#! /bin/sh

envpkgs="$gtk $libpng $zlib"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$PATH

NIX_CFLAGS_COMPILE="-I$libpng/include -I$zlib/include $NIX_CFLAGS_COMPILE"

tar xvfz $src || exit 1
cd gqview-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
