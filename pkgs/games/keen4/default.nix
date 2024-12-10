{
  lib,
  stdenv,
  fetchurl,
  dosbox,
  unzip,
}:

stdenv.mkDerivation {
  name = "keen4";

  src = fetchurl {
    url = "http://tarballs.nixos.org/keen4.zip";
    sha256 = "12rnc9ksl7v6l8wsxvr26ylkafzq80dbsa7yafzw9pqc8pafkhx1";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/keen4
    mv * $out/share/keen4

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

    ${dosbox}/bin/dosbox ./KEEN4E.EXE -fullscreen -exit || true

    # Cleanup the symlinks.
    for i in *; do
        if test -L "\$i"; then
            rm "\$i"
        fi
    done
    EOF
    chmod +x $out/bin/keen4
  '';

  meta = {
    description = "Commander Keen Episode 4: Secret of the Oracle";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.eelco ];
  };
}
