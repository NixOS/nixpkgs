source $stdenv/setup
genericBuild
cd $out/bin

find . -type f | while read fn; do
    cat $fn | sed "s|/nix/store/[a-z0-9]*-|/nix/store/ffffffffffffffffffffffffffffffff-|g" > $fn.tmp
    if test -x $fn; then chmod +x $fn.tmp; fi
    mv $fn.tmp $fn
done

strip $out/bin/bash
ln -s bash sh
