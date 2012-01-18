source $stdenv/setup

installFlags="PREFIX=$out INSTALL=install"

mkdir -p "$out/bin"
mkdir -p "$out/man/man1"

genericBuild
