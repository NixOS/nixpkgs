#! /bin/sh -e

. $stdenv/setup 

tar xvfj $src 
cd nix-* 
./configure --prefix=$out \
 --with-store-dir=/nix/store --localstatedir=/nix/var
make 
make install 
