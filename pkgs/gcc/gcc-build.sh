#! /bin/sh

. $stdenv/setup || exit 1

tar xvfj $src || exit 1
mkdir build || exit 1
cd build || exit 1
../gcc-*/configure --prefix=$out --enable-languages=c,c++ || exit 1
make bootstrap || exit 1
make install || exit 1
