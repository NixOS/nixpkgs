#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd bash-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
(cd $out/bin; ln -s bash sh) || exit 1
