source $stdenv/setup

prefix=$out
export prefix

ensureDir "$out/usr/share/man/man8/"
ensureDir "$out/usr/share/man/man5/"
ensureDir "$out/usr/sbin"

NIX_CFLAGS_COMPILE="-DCONFIG_X86_L1_CACHE_SHIFT=0 $NIX_CFLAGS_COMPILE"

genericBuild
