#! /bin/sh -e

buildinputs="$gettext"
. $stdenv/setup 

tar xvfz $src 
cd e2fsprogs-* 
./configure --prefix=$out --enable-dynamic-e2fsck
make 
make install 
