#! /bin/sh

envpkgs="$zlib $libpng $libjpeg $expat $freetype"
. $stdenv/setup || exit 1

NIX_CFLAGS_COMPILE="-I$zlib/include -I$libpng/include -I$libjpeg/include -I$expat/include $NIX_CFLAGS_COMPILE"

tar xvfz $src || exit 1
cd graphviz-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib || exit 1
make || exit 1
make install || exit 1
