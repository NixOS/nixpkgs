#! /bin/sh

export PATH=/bin:/usr/bin

tar xvfj $glibcSrc || exit 1
(cd glibc-* && tar xvfj $linuxthreadsSrc) || exit 1

mkdir build || exit 1
cd build || exit 1
../glibc-*/configure --prefix=$out --enable-add-ons || exit 1

make || exit 1
make install || exit 1
