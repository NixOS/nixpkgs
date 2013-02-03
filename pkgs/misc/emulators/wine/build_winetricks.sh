#!/bin/sh
source $stdenv/setup
mkdir -p $out/bin
cp $src/src/winetricks $out/bin/winetricks
chmod +x $out/bin/winetricks
cd $out/bin
patch -u -p0 < $patch

