#! /bin/sh

. $stdenv/setup || exit 1
export PATH=$binutils/bin:$PATH

tar xvfj $src || exit 1
mkdir build || exit 1
cd build || exit 1
../gcc-*/configure --prefix=$out --enable-languages=c,c++ || exit 1

extraflags="$NIX_CFLAGS $NIX_LDFLAGS -Wl,-s"

mf=Makefile
sed \
 -e "s^FLAGS_FOR_TARGET =\(.*\)^FLAGS_FOR_TARGET = \1 $extraflags^" \
 < $mf > $mf.tmp || exit 1
mv $mf.tmp $mf

mf=gcc/Makefile
sed \
 -e "s^X_CFLAGS =\(.*\)^X_CFLAGS = \1 $extraflags^" \
 < $mf > $mf.tmp || exit 1
mv $mf.tmp $mf

make bootstrap || exit 1
make install || exit 1
