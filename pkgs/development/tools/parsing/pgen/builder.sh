#! /bin/sh

buildinputs="$aterm $getopt $toolbuslib $ptsupport $sdfsupport $asfsupport $ascsupport $sglr"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd pgen-* || exit 1
./configure --prefix=$out --with-aterm=$aterm \
                          --with-toolbuslib=$toolbuslib \
                          --with-pt-support=$ptsupport \
                          --with-sdf-support=$sdfsupport \
                          --with-asf-support=$asfsupport \
                          --with-asc-support=$asfsupport \
                          --with-sglr=$sglr  || exit 1
make install || exit 1

echo "$getopt" > $out/propagated-build-inputs || exit 1
