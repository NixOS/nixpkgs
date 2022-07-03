{
  haskell,
  expect,
  haskellPackages,
  installShellFiles,
}: let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;
  overrides = {
    passthru.updateScript = ./update.sh;
    testTarget = "unit-tests";
    buildTools = [installShellFiles];
    postInstall = ''
      substitute "exe-sh/nom-build" "$out/bin/nom-build" \
        --replace 'unbuffer' '${expect}/bin/unbuffer' \
        --replace 'nom' "$out/bin/nom"
      chmod a+x $out/bin/nom-build
      installShellCompletion --zsh --name _nom-build completions/completion.zsh
    '';
  };
in
  justStaticExecutables
  (overrideCabal overrides
    (haskellPackages.callPackage ./generated-package.nix {}))
