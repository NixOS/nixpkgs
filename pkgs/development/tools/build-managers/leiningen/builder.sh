#!/bin/bash

source $stdenv/setup

mkdir -pv $out/bin $out/share/java

out_bin=$out/bin/lein

cp -v $src $out_bin
cp -v $jarsrc "$out/share/java/$name-standalone.jar"

for p in $patches;
do
    patch --verbose $out_bin -p0 < $p
done
chmod -v 755 $out_bin

patchShebangs $out

wrapProgram $out_bin \
    --prefix PATH ":" "${stdenv.lib.makeBinPath [ rlwrap coreutils findutils ]}" \
    --set LEIN_GPG ${gnupg1compat}/bin/gpg \
    --set JAVA_CMD ${jdk}/bin/java
