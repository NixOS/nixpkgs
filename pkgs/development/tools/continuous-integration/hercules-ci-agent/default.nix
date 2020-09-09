{ gnutar, gzip, git, haskell, haskellPackages, lib, makeWrapper }:
let
  inherit (haskell.lib) overrideCabal addBuildDepends;
  inherit (lib) makeBinPath;
  pkg =
    # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
    overrideCabal
      (addBuildDepends (haskell.lib.justStaticExecutables haskellPackages.hercules-ci-agent) [ makeWrapper ])
      (o: {
        postInstall = ''
          ${o.postInstall or ""}
          mkdir -p $out/libexec
          mv $out/bin/hercules-ci-agent $out/libexec
          makeWrapper $out/libexec/hercules-ci-agent $out/bin/hercules-ci-agent --prefix PATH : ${makeBinPath [ gnutar gzip git ]}
        '';
      });
in pkg // {
    meta = pkg.meta // {
      position = toString ./default.nix + ":1";
    };
  }
