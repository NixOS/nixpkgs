#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd SWIG-* || exit 1
./configure --prefix=$out || exit 1
gmake || exit 1
gmake install || exit 1
