#! /bin/sh

buildinputs="$aterm $getopt"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd sdf2-bundle-* || exit 1
./configure --prefix=$out --with-aterm=$aterm || exit 1
make install || exit 1

echo "$getopt" > $out/propagated-build-inputs || exit 1
