#! /bin/sh

. $stdenv/setup || exit 1
export PATH=$yacc/bin:$PATH

tar xvfz $src || exit 1
cd flex-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
