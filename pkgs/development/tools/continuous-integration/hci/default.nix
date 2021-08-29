{ haskell, haskellPackages, lib, makeWrapper, runc, stdenv }:
let
  inherit (haskell.lib) overrideCabal addBuildDepends;
  inherit (lib) makeBinPath;
  bundledBins = lib.optional stdenv.isLinux runc;

  pkg =
    # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
    overrideCabal
      (addBuildDepends (haskell.lib.justStaticExecutables haskellPackages.hercules-ci-cli) [ makeWrapper ])
      (o: {
        postInstall = ''
          ${o.postInstall or ""}
          mkdir -p $out/libexec
          mv $out/bin/hci $out/libexec
          makeWrapper $out/libexec/hci $out/bin/hci --prefix PATH : ${makeBinPath bundledBins}
        '';
      });
in pkg // {
    meta = pkg.meta // {
      position = toString ./default.nix + ":1";
    };
  }
