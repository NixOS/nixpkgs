#! /bin/sh -e

buildinputs="$aterm $bdb"
. $stdenv/setup

tar xvfj $src
cd nix-*
./configure --prefix=$out \
 --with-store-dir=/nix/store --localstatedir=/nix/var \
 --with-aterm=$aterm --with-bdb=$bdb
make
make install
