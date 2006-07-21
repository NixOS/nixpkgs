#! /bin/sh -e

source $stdenv/setup

mkdir $out
mkdir $out/bin

for i in $createModules; do
    dst=$out/bin/$(basename $i | cut -c34-)
    sed \
        -e "s^@coreutils\@^$coreutils^g" \
        -e "s^@findutils\@^$findutils^g" \
        -e "s^@kernelpkgs\@^$kernelpkgs^g" \
        -e "s^@module_init_tools\@^$module_init_tools^g" \
        -e "s^@nix\@^$nix^g" \
        < $i > $dst
    chmod +x $dst
done
