#! /bin/sh -e

buildinputs="$ncurses"
. $stdenv/setup

tar xvfz $src
cd texinfo-*
./configure --prefix=$out
make
make install
