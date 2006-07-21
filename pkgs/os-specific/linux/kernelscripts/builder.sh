#! /bin/sh -e

source $stdenv/setup

mkdir $out
mkdir $out/bin

for i in $createModules; do
    dst=$out/bin/$(basename $i | cut -c34-)
    sed \
        -e "s^@coreutils\@^$coreutils^g" \
        -e "s^@nix\@^$nix^g" \
        < $i > $dst
    chmod +x $dst
done
