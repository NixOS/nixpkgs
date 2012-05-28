#!/bin/bash

set -e

source $stdenv/setup

mkdir -pv $out/bin $out/lib

out_bin=$out/bin/lein

cp -v $src $out_bin
cp -v $jarsrc $out/lib
cp -v $clojuresrc $out/lib

for p in $patches;
do
    patch --verbose $out_bin -p0 < $p
done
chmod -v 755 $out_bin

patchShebangs $out

wrapProgram $out_bin --prefix PATH ":" ${rlwrap}/bin

echo "Testing out \"lein version\"..."
$out_bin version
echo "Success."
