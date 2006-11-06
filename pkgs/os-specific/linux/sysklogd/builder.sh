source $stdenv/setup

prefix=$out
export prefix

installFlags="BINDIR=$out/sbin MANDIR=$out/share/man"

ensureDir "$out/share/man/man8/"
ensureDir "$out/share/man/man5/"
ensureDir "$out/sbin"

genericBuild
