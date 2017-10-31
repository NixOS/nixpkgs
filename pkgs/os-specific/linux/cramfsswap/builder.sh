source $stdenv/setup

export DESTDIR=$out
mkdir -p $out/usr/bin

genericBuild
