#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd sdf2-* || exit 1
./configure --prefix=$out --with-aterm=$aterm || exit 1
make || exit 1
make install || exit 1
