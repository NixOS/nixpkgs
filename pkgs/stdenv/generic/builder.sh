p1=$param1
p2=$param2
p3=$param3
p4=$param4
p5=$param5
_preHook="$preHook"
_postHook="$postHook"
preHook=
postHook=

export PATH=
for i in $initialPath; do
    if test "$i" = /; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out

# Can't use substitute() here, because replace may not have been
# built yet (in the bootstrap).
sed \
    -e "s^@preHook@^$_preHook^g" \
    -e "s^@postHook@^$_postHook^g" \
    -e "s^@initialPath@^$initialPath^g" \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@shell@^$shell^g" \
    -e "s^@param1@^$p1^g" \
    -e "s^@param2@^$p2^g" \
    -e "s^@param3@^$p3^g" \
    -e "s^@param4@^$p4^g" \
    -e "s^@param5@^$p5^g" \
    < "$setup" > "$out/setup"

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir $out/nix-support
echo $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
