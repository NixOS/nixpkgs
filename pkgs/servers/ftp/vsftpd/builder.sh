source $stdenv/setup

ensureDir "$out/bin"
ensureDir "$out/sbin"

ensureDir "$out/man/man8"
ensureDir "$out/man/man5"

genericBuild
