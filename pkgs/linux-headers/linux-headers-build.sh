#! /bin/sh

. $stdenv/setup || exit 1

mkdir $out || exit 1
cd $out || exit 1
tar xvfj $src 'linux-*/include/linux' 'linux-*/include/asm-i386' || exit 1
mv linux-*/include . || exit 1
rmdir linux-* || exit 1
cd include || exit 1
ln -s asm-i386 asm || exit 1
