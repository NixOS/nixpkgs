#!/bin/bash

set -e

source $stdenv/setup

mkdir -pv $out/bin $out/lib

out_bin=$out/bin/lein

cp -v $src $out_bin
cp -v $jarsrc $out/lib
cp -v $clojure/lib/java/* $out/lib

for p in $patches;
do
    patch --verbose $out_bin -p0 < $p
done
chmod -v 755 $out_bin

patchShebangs $out

wrapProgram $out_bin \
    --prefix PATH ":" ${rlwrap}/bin \
    --set LEIN_GPG ${gnupg}/bin/gpg
