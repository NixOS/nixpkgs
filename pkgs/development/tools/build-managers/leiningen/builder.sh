#!/bin/bash

set -e

source $stdenv/setup

mkdir -pv $out/bin $out/lib

out_bin=$out/bin/lein

cp -v $src $out_bin
cp -v $jarsrc $out/lib
cp -v $clojuresrc $out/lib

patch --verbose $out_bin -p0 < $patches
chmod -v 755 $out_bin

echo "Testing out \"lein version\"..."
$out_bin version
echo "Success."
