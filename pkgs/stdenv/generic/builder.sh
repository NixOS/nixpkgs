p1=$param1
p2=$param2
p3=$param3
p4=$param4
p5=$param5

source $stdenv/setup

mkdir $out

# Can't use substitute() here, because replace may not have been
# built yet (in the bootstrap).
sed \
    -e "s^@preHook@^$preHook^" \
    -e "s^@postHook@^$postHook^" \
    -e "s^@initialPath@^$initialPath^" \
    -e "s^@gcc@^$gcc^" \
    -e "s^@shell@^$shell^" \
    -e "s^@param1@^$p1^" \
    -e "s^@param2@^$p2^" \
    -e "s^@param3@^$p3^" \
    -e "s^@param4@^$p4^" \
    -e "s^@param5@^$p5^" \
    < "$setup" > "$out/setup"
