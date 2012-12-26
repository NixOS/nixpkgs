export PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out

echo "$preHook" > $out/setup
cat "$setup" >> $out/setup

if [ "$withNixImpure" == 1 ]; then
    # sed wants \&\& for a &&
    niximpure='test -f /niximpure/impure.sh \&\& . /niximpure/impure.sh'
fi

sed -e "s^@initialPath@^$initialPath^g" \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@shell@^$shell^g" \
    -e "s^@niximpure@^$niximpure^g" \
    < $out/setup > $out/setup.tmp
mv $out/setup.tmp $out/setup

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir $out/nix-support
echo $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
