{ stdenv
, rtpPath ? "share/vim-plugins"
, vim
}:

rec {
  addRtp = path: attrs: derivation:
    derivation // { rtp = "${derivation}/${path}"; } // {
      overrideAttrs = f: buildVimPlugin (attrs // f attrs);
    };

  buildVimPlugin = attrs@{
    name ? "${attrs.pname}-${attrs.version}",
    namePrefix ? "vimplugin-",
    src,
    unpackPhase ? "",
    configurePhase ? "",
    buildPhase ? "",
    preInstall ? "",
    postInstall ? "",
    path ? stdenv.lib.getName name,
    addonInfo ? null,
    ...
  }:
    addRtp "${rtpPath}/${path}" attrs (stdenv.mkDerivation (attrs // {
      name = namePrefix + name;

      inherit unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = ''
        runHook preInstall

        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target

        # build help tags
        if [ -d "$target/doc" ]; then
          echo "Building help tags"
          if ! ${vim}/bin/vim -N -u NONE -i NONE -n -E -s -V1 -c "helptags $target/doc" +quit!; then
            echo "Failed to build help tags!"
            exit 1
          fi
        else
          echo "No docs available"
        fi

        if [ -n "$addonInfo" ]; then
          echo "$addonInfo" > $target/addon-info.json
        fi

        runHook postInstall
      '';
    }));

  buildVimPluginFrom2Nix = attrs: buildVimPlugin ({
    buildPhase = ":";
    configurePhase =":";
  } // attrs);
}
