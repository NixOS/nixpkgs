. $stdenv/setup
if test -n "$coreutils"; then PATH=$coreutils/bin:$PATH; fi
genericBuild