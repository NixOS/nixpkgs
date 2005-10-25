source $stdenv/setup

export CRACKLIB_DICTPATH=$cracklib/lib

configureFlags="--enable-includedir=$out/include"

genericBuild
