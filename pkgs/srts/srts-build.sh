#! /bin/sh

set -e

. $stdenv/setup

export PATH=$autoxt/bin:$PATH

echo "out: $out"
echo "pwd: `pwd`"
echo "src: $src"
ls $src

cp -r $src srts
ls

cd srts
./bootstrap
./configure --prefix=$out --with-aterm=$aterm
make
make install

