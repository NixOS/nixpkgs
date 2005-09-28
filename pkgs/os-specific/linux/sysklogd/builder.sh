source $stdenv/setup

prefix=$out
export prefix

ensureDir "$out/usr/share/man/man8/"
ensureDir "$out/usr/share/man/man5/"
ensureDir "$out/usr/sbin"

genericBuild
