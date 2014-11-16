export PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out

echo "export SHELL=$shell" > $out/setup
echo "initialPath=\"$initialPath\"" >> $out/setup
echo "defaultNativeBuildInputs=\"$defaultNativeBuildInputs\"" >> $out/setup
echo "$preHook" >> $out/setup
cat "$setup" >> $out/setup

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir $out/nix-support
echo $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
