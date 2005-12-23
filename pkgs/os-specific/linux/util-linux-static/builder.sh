source $stdenv/setup

export LDFLAGS=-static
export DESTDIR=$out

genericBuild

strip $out/bin/*
strip $out/sbin/*
