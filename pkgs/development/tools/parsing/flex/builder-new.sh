#! /bin/sh

export buildinputs="$yacc $m4"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd flex-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1

echo "$m4" > $out/propagated-build-inputs || exit 1
