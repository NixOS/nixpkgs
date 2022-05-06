{ haskell, haskellPackages, lib, makeWrapper, runc, stdenv }:
let
  inherit (haskell.lib.compose) overrideCabal addBuildDepends justStaticExecutables;
  inherit (lib) makeBinPath;
  bundledBins = lib.optional stdenv.isLinux runc;

  pkg =
    # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
    overrideCabal
      (o: {
        postInstall = ''
          ${o.postInstall or ""}
          mkdir -p $out/libexec
          mv $out/bin/hci $out/libexec
          makeWrapper $out/libexec/hci $out/bin/hci --prefix PATH : ${lib.escapeShellArg (makeBinPath bundledBins)}
        '';
      })
      (addBuildDepends [ makeWrapper ] (justStaticExecutables haskellPackages.hercules-ci-cli));
in pkg // {
    meta = pkg.meta // {
      position = toString ./default.nix + ":1";
    };
  }
