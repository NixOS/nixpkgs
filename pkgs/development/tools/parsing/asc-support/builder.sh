#! /bin/sh

buildinputs="$aterm $ptsupport $toolbuslib $asfsupport"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd asc-support-* || exit 1
./configure --prefix=$out --with-aterm=$aterm --with-toolbuslib=$toolbuslib --with-pt-support=$ptsupport --with-asf-support=$asfsupport || exit 1
make install || exit 1
