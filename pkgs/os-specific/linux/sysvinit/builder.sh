#! /bin/sh -e

buildinputs="$patch"
. $stdenv/setup

tar xvfz $src
cd sysvinit-*
patch -p1 < $srcPatch
cd src
make
mkdir $out
mkdir $out/bin
mkdir $out/sbin
mkdir $out/include
mkdir $out/share
mkdir $out/share/man
mkdir $out/share/man/man1
mkdir $out/share/man/man5
mkdir $out/share/man/man8
make ROOT=$out install
