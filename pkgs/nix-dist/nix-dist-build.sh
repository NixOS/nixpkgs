#! /bin/sh

. $stdenv/setup || exit 1

cp --preserve=all -rv $src nix
cd nix || exit 1
cp -p $bdbSrc externals/db-4.0.14.tar.gz || exit 1
cp -p $atermSrc externals/aterm-2.0.tar.gz || exit 1
autoreconf -i || exit 1
./configure || exit 1 
make dist || exit 1
cp nix-0.2pre1.tar.gz $out || exit 1
