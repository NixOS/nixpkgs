{
  haskell,
  haskellPackages,
  installShellFiles,
  lib,
}:
let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  overrides = {
    passthru.updateScript = ./update.sh;

    # nom has unit-tests and golden-tests
    # golden-tests call nix and thus can’t be run in a nix build.
    testTarget = "unit-tests";

    buildTools = [ installShellFiles ];
    postInstall = ''
      ln -s nom "$out/bin/nom-build"
      ln -s nom "$out/bin/nom-shell"
      chmod a+x $out/bin/nom-build
      installShellCompletion completions/*
    '';
  };
  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
