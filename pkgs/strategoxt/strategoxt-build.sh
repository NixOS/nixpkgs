#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd strategoxt-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out --with-aterm=$aterm --with-sdf=$sdf2 || exit 1
make || exit 1
make install || exit 1
