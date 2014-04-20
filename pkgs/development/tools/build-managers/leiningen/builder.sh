#!/bin/bash

source $stdenv/setup

mkdir -pv $out/bin $out/share/java

out_bin=$out/bin/lein

cp -v $src $out_bin
cp -v $jarsrc $out/share/java
cp -v $clojure/share/java/* $out/share/java/

for p in $patches;
do
    patch --verbose $out_bin -p0 < $p
done
chmod -v 755 $out_bin

patchShebangs $out

wrapProgram $out_bin \
    --prefix PATH ":" "${rlwrap}/bin:${coreutils}/bin:${findutils}/bin" \
    --set LEIN_GPG ${gnupg}/bin/gpg \
    --set JAVA_CMD ${jdk}/bin/java
