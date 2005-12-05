source $stdenv/setup

installFlags="PREFIX=$out INSTALL=install"

ensureDir "$out/bin"
ensureDir "$out/man/man1"

genericBuild
