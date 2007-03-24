source $stdenv/setup

export DESTDIR=$out
ensureDir $out/usr/bin

genericBuild
