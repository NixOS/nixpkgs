{ gnutar, gzip, git, haskell, haskellPackages, lib, makeWrapper, nixos, runc, stdenv }:
let
  inherit (haskell.lib.compose) overrideCabal addBuildTools justStaticExecutables;
  inherit (lib) makeBinPath;
  bundledBins = [ gnutar gzip git ] ++ lib.optional stdenv.isLinux runc;

  pkg =
    # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
    overrideCabal
      (o: {
        postInstall = ''
          ${o.postInstall or ""}
          mkdir -p $out/libexec
          mv $out/bin/hercules-ci-agent $out/libexec
          makeWrapper $out/libexec/hercules-ci-agent $out/bin/hercules-ci-agent --prefix PATH : ${lib.escapeShellArg (makeBinPath bundledBins)}
        '';
      })
      (addBuildTools [ makeWrapper ] (justStaticExecutables haskellPackages.hercules-ci-agent));
in pkg.overrideAttrs (o: {
    meta = o.meta // {
      position = toString ./default.nix + ":1";
    };
    passthru = o.passthru // {
      # Does not test the package, but evaluation of the related NixOS module.
      tests.nixos-minimal-config = nixos {
        boot.loader.grub.enable = false;
        fileSystems."/".device = "bogus";
        services.hercules-ci-agent.enable = true;
      };
    };
  })
