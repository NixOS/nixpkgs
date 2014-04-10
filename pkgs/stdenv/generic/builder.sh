export PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out
mkdir $out/bin

echo "$preHook" > $out/setup
cat "$setup" >> $out/setup

real_date=$(type -Pa date | sed 1d)

if test -n "$real_date"; then
    cat >$out/bin/date <<EOF
#!$shell
exec $real_date -d0 "\$@"
EOF
    chmod +x $out/bin/date
    initialPath="$out $initialPath"
fi

sed -e "s^@initialPath@^$initialPath^g" \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@shell@^$shell^g" \
    -e "s^@needsPax@^$needsPax^g" \
    -e "s^@libfaketime@^$libfaketime^g" \
    < $out/setup > $out/setup.tmp
mv $out/setup.tmp $out/setup

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir $out/nix-support
echo $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
