#! /bin/sh

export PATH=/bin:/usr/bin

tar xvfz $src || exit 1
cd sdf2-* || exit 1
LDFLAGS=-s ./configure --prefix=$out --with-aterm=$aterm || exit 1
make || exit 1
make install || exit 1
