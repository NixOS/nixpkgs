p1=$param1
p2=$param2
p3=$param3
p4=$param4
p5=$param5

. $stdenv/setup
. $substitute

mkdir $out

substitute "$setup" "$out/setup" \
    --subst-var preHook \
    --subst-var postHook \
    --subst-var initialPath \
    --subst-var gcc \
    --subst-var shell \
    --subst-var-by param1 "$p1" \
    --subst-var-by param2 "$p2" \
    --subst-var-by param3 "$p3" \
    --subst-var-by param4 "$p4" \
    --subst-var-by param5 "$p5"
