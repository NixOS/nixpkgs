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
      ln -s nom "$out/bin/nom-build"
      ln -s nom "$out/bin/nom-shell"
      chmod a+x $out/bin/nom-build
      installShellCompletion --zsh --name _nom-build completions/completion.zsh
    '';
  };
in
  justStaticExecutables
  (overrideCabal overrides
    (haskellPackages.callPackage ./generated-package.nix {}))
