#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin

tar xvfj $src || exit 1
cd glib-* || exit 1
LDFLAGS=-s ./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
