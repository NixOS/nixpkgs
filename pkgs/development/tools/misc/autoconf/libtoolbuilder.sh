#! /bin/sh

buildinputs="$m4 $perl $out"
. $stdenv/setup || exit 1

tar xvfj $autoconfsrc || exit 1
cd autoconf-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1

buildinputs="$m4 $perl $out"
. $stdenv/setup || exit 1

tar xvfj $automakesrc || exit 1
cd automake-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1

buildinputs="$m4 $perl $out"
. $stdenv/setup || exit 1

tar xvfz $libtoolsrc || exit 1
cd libtool-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1