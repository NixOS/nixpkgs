#! /bin/sh

set -e

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup

export PATH=$autoxt/bin:$PATH

ls -l
pwd

gtar zxf $src/$name.tar.gz

cd $name
./bootstrap
./configure --prefix=$out $*
make
make install

