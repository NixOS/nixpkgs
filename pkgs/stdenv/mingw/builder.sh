# the other stdenv could change the SHELL variable,
# so we have to remember its value.
origShell=$SHELL
origGcc=$GCC

source $STDENV/setup

mkdir $OUT

SHELL=$origShell
GCC=$origGcc

export NIX_BUILD_TOP=$(pwd)

substitute "$SETUP" "$OUT/setup" \
    --subst-var INITIALPATH \
    --subst-var GCC \
    --subst-var SHELL
