#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin

tar xvfj $src
cd glib-*
./configure --prefix=$out
make
make install
