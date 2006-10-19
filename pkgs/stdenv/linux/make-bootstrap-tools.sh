source $stdenv/setup

ensureDir $out/in-nixpkgs
ensureDir $out/on-server

nukeRefs() {
    # Dirty, disgusting, but it works ;-)
    fileName=$1
    cat $fileName | sed "s|/nix/store/[a-z0-9]*-|/nix/store/ffffffffffffffffffffffffffffffff-|g" > $fileName.tmp
    if test -x $fileName; then chmod +x $fileName.tmp; fi
    mv $fileName.tmp $fileName
}

cp $bash/bin/bash $out/in-nixpkgs
cp $bzip2/bin/bunzip2 $out/in-nixpkgs
cp $coreutils/bin/cp $out/in-nixpkgs

nukeRefs $out/in-nixpkgs/bash

chmod +w $out/in-nixpkgs/*
strip -s $out/in-nixpkgs/*
