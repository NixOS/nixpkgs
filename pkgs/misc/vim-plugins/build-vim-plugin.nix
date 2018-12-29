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
    path ? (builtins.parseDrvName name).name,
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
          ${vim}/bin/vim -N -u NONE -i NONE -n -E -s -c "helptags $1/doc" +quit! || echo "docs to build failed"
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
