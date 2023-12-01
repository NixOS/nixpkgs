{ haskell, haskellPackages, lib, makeWrapper, runc, stdenv, emptyDirectory }:
let
  inherit (haskell.lib.compose) overrideCabal addBuildTools justStaticExecutables appendConfigureFlags;
  inherit (lib) makeBinPath;
  bundledBins = lib.optional stdenv.isLinux runc;

  overrides = old: {
    hercules-ci-agent =
      overrideCabal
        (o: {
          isLibrary = true;
          isExecutable = false;
          postInstall = ""; # ignore completions
          enableSharedExecutables = false;
          buildTarget = "lib:hercules-ci-agent hercules-ci-agent-unit-tests";
          configureFlags = o.configureFlags or [ ] ++ [
            "--bindir=${emptyDirectory}/hercules-ci-built-without-binaries/no-bin"
          ];
        })
        old.hercules-ci-agent;
  };

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
      (addBuildTools [ makeWrapper ] (justStaticExecutables (haskellPackages.hercules-ci-cli.override overrides)));
in pkg // {
    meta = pkg.meta // {
      position = toString ./default.nix + ":1";
    };
  }
