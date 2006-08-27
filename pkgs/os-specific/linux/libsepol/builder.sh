source $stdenv/setup

export DESTDIR=$out
export PREFIX=$out

genericBuild
