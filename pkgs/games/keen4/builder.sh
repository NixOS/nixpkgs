source $stdenv/setup

mkdir -p $out/share/keen4
unzip -j $dist -d $out/share/keen4

mkdir -p $out/bin
cat > $out/bin/keen4 <<EOF
#! $SHELL -e
if test -z "\$HOME"; then
    echo "HOME directory not set"
    exit 1
fi

# Game wants to write in the current directory, but of course we can't
# let it write in the Nix store.  So create symlinks to the game files
# in ~/.keen4 and execute game from there.
mkdir -p \$HOME/.keen4
cd \$HOME/.keen4

ln -sf $out/share/keen4/* .

$dosbox/bin/dosbox ./KEEN4E.EXE -fullscreen -exit || true

# Cleanup the symlinks.
for i in *; do
    if test -L "\$i"; then
        rm "\$i"
    fi
done
EOF
chmod +x $out/bin/keen4