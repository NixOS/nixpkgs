#! /bin/sh

set -e

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup 

export PATH=$autoxt/bin:$PATH

cp -r $src $name
cd $name
./bootstrap
./configure --prefix=$out --with-aterm=$aterm --with-srts=$srts
make
make install
