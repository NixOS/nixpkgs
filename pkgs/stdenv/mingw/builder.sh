source $STDENV/setup
source $SUBSTITUTE

mkdir $OUT

substitute "$SETUP" "$OUT/setup" \
    --subst-var INITIALPATH \
    --subst-var GCC \
    --subst-var SHELL
