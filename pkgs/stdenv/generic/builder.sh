export PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    PATH=$PATH${PATH:+:}$i/bin
done

mkdir $out

# Buid the setup script
echo "export SHELL=$shell" > $out/setup
echo "initialPath=\"$initialPath\"" >> $out/setup
echo "$preHook" >> $out/setup
cat "$setup" >> $out/setup

# Allow the user to install stdenv using nix-env and get the packages
# in stdenv.
mkdir -p "$out/nix-support"
echo '# Hack to induce runtime dependencies on the default inputs' \
    > "$out/nix-support/default-inputs.txt"
printf '%s\n' $defaultNativeBuildInputs $defaultBuildInputs \
    >> "$out/nix-support/default-inputs.txt"
if [ "$propagatedUserEnvPkgs" ]; then
    printf '%s ' $propagatedUserEnvPkgs \
        > "$out/nix-support/propagated-user-env-packages"
fi
