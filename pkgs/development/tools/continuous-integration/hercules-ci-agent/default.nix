{ gnutar, gzip, git, haskell, haskellPackages, lib, makeWrapper, runc, stdenv }:
let
  inherit (haskell.lib) overrideCabal addBuildDepends;
  inherit (lib) makeBinPath;
  bundledBins = [ gnutar gzip git ] ++ lib.optional stdenv.isLinux runc;

  pkg =
    # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
    overrideCabal
      (addBuildDepends (haskell.lib.justStaticExecutables haskellPackages.hercules-ci-agent) [ makeWrapper ])
      (o: {
        postInstall = ''
          ${o.postInstall or ""}
          mkdir -p $out/libexec
          mv $out/bin/hercules-ci-agent $out/libexec
          makeWrapper $out/libexec/hercules-ci-agent $out/bin/hercules-ci-agent --prefix PATH : ${makeBinPath bundledBins}
        '';
      });
in pkg // {
    meta = pkg.meta // {
      position = toString ./default.nix + ":1";
    };
  }
