#! /bin/sh

buildinputs="$aterm $ptsupport"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd asf-support-* || exit 1
./configure --prefix=$out --with-aterm=$aterm --with-pt-support=$ptsupport || exit 1
make install || exit 1
