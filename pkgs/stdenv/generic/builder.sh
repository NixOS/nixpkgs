export PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out

echo "export SHELL=$shell" > $out/setup
echo "initialPath=\"$initialPath\"" >> $out/setup
echo "defaultNativeBuildInputs=\"$defaultNativeBuildInputs\"" >> $out/setup
echo "defaultBuildInputs=\"$defaultBuildInputs\"" >> $out/setup
echo "$preHook" >> $out/setup
cat "$setup" >> $out/setup

# Setup fake date
mkdir $out/bin
real_date=$(type -Pa date | sed 1d)
if test -n "$real_date"; then
    cat >$out/bin/date <<EOF
#!$shell
exec $real_date -d0 "\$@"
EOF
    chmod +x $out/bin/date
    initialPath="$out $initialPath"
fi

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir $out/nix-support
if [ "$propagatedUserEnvPkgs" ]; then
    printf '%s ' $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
fi
