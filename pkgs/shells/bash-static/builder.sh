source $stdenv/setup
genericBuild
cd $out/bin
strip $out/bin/bash
ln -s bash sh
