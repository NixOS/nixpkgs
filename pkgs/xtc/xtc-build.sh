#! /bin/sh

set -e

. $stdenv/setup 

export PATH=$autoxt/bin:$PATH

cp -r $src $name
cd $name
./bootstrap
./configure --prefix=$out --with-aterm=$aterm --with-srts=$srts
make
make install
