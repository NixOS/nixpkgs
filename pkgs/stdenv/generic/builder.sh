export PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out

sed \
    -e "s^@preHook@^$preHook^g" \
    -e "s^@postHook@^$postHook^g" \
    -e "s^@initialPath@^$initialPath^g" \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@shell@^$shell^g" \
    < "$setup" > "$out/setup"

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir $out/nix-support
echo $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
