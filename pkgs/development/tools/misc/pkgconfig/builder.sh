#! /bin/sh

. $stdenv/setup

tar xvfz $src
cd pkgconfig-*
./configure --prefix=$out
make
mkdir $out
make install

mkdir $out/nix-support
cp $setupHook $out/nix-support/setup-hook