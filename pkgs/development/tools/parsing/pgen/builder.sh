#! /bin/sh -e

buildinputs="$aterm $getopt $toolbuslib $ptsupport $sdfsupport $asfsupport $ascsupport $sglr"
. $stdenv/setup

tar zxf $src
cd pgen-*
./configure --prefix=$out --with-aterm=$aterm \
                          --with-toolbuslib=$toolbuslib \
                          --with-pt-support=$ptsupport \
                          --with-sdf-support=$sdfsupport \
                          --with-asf-support=$asfsupport \
                          --with-asc-support=$asfsupport \
                          --with-sglr=$sglr 
make install

mkdir $out/nix-support
echo "$getopt" > $out/nix-support/propagated-build-inputs
