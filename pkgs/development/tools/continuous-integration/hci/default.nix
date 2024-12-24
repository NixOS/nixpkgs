{
  crun,
  haskell,
  haskellPackages,
  lib,
  makeWrapper,
  stdenv,
  emptyDirectory,
}:
let
  inherit (haskell.lib.compose)
    overrideCabal
    addBuildTools
    justStaticExecutables
    appendConfigureFlags
    ;
  inherit (lib) makeBinPath;
  bundledBins = lib.optional stdenv.hostPlatform.isLinux crun;

  overrides = old: {
    hercules-ci-agent = overrideCabal (o: {
      isLibrary = true;
      isExecutable = false;
      postInstall = ""; # ignore completions
      enableSharedExecutables = false;
      buildTarget = "lib:hercules-ci-agent hercules-ci-agent-unit-tests";
      configureFlags = o.configureFlags or [ ] ++ [
        "--bindir=${emptyDirectory}/hercules-ci-built-without-binaries/no-bin"
      ];
    }) old.hercules-ci-agent;
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
      (
        addBuildTools [ makeWrapper ]
          # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
          (
            (
              if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
                lib.id
              else
                haskell.lib.compose.justStaticExecutables
            )
              (haskellPackages.hercules-ci-cli.override overrides)
          )
      );
in
pkg
// {
  meta = pkg.meta // {
    position = toString ./default.nix + ":1";
  };
}
