#! /bin/sh -e

buildinputs="$aterm $getopt"
. $stdenv/setup

tar zxf $src
cd sdf2-bundle-*
./configure --prefix=$out --with-aterm=$aterm
make install

mkdir $out/nix-support
echo "$getopt" > $out/nix-support/propagated-build-inputs
