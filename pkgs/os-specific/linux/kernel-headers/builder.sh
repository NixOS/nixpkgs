#! /bin/sh

. $stdenv/setup

tar xvfj $src
cd linux-*

make include/linux/version.h

mkdir $out
mkdir $out/include
cp -prvd include/linux include/asm-i386 $out/include
cd $out/include
ln -s asm-i386 asm

# config.h includes autoconf.h, which doesn't exist.
echo -n > $out/include/linux/autoconf.h
