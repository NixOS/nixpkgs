{ lib, stdenv
, rtpPath
, vim
, vimGenDocHook
}:

rec {
  addRtp = path: attrs: derivation:
    derivation // { rtp = "${derivation}"; } // {
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
    path ? ".",
    addonInfo ? null,
    ...
  }:
    addRtp "${rtpPath}/${path}" attrs (stdenv.mkDerivation (attrs // {
      name = namePrefix + name;

      # dont move the doc folder since vim expects it
      forceShare= [ "man" "info" ];

      nativeBuildInputs = attrs.nativeBuildInputs or []
      ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) vimGenDocHook;
      inherit unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = ''
        runHook preInstall

        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target

        runHook postInstall
      '';
    }));

  buildVimPluginFrom2Nix = attrs: buildVimPlugin ({
    # vim plugins may override this
    buildPhase = ":";
    configurePhase =":";
  } // attrs);
}
