#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd getopt-* || exit 1
make || exit 1
make install prefix=$out || exit 1
