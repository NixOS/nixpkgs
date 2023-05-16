{
  haskell,
<<<<<<< HEAD
  haskellPackages,
  installShellFiles,
  lib,
}: let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  overrides = {
    passthru.updateScript = ./update.sh;

    # nom has unit-tests and golden-tests
    # golden-tests call nix and thus can’t be run in a nix build.
    testTarget = "unit-tests";

=======
  expect,
  haskellPackages,
  installShellFiles,
  lib
}: let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;
  overrides = {
    passthru.updateScript = ./update.sh;
    testTarget = "unit-tests";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    buildTools = [installShellFiles];
    postInstall = ''
      ln -s nom "$out/bin/nom-build"
      ln -s nom "$out/bin/nom-shell"
      chmod a+x $out/bin/nom-build
      installShellCompletion --zsh --name _nom-build completions/completion.zsh
    '';
<<<<<<< HEAD
  };
  raw-pkg = haskellPackages.callPackage ./generated-package.nix {};
in
  lib.pipe
  raw-pkg
=======
    mainProgram = "nom";
  };
  nom-pkg = haskellPackages.callPackage ./generated-package.nix { };
  nom-pkg-with-scope = nom-pkg.overrideScope (hfinal: hprev: {
    hermes-json = hfinal.hermes-json_0_2_0_1;
  });
in
lib.pipe
  nom-pkg-with-scope
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  [
    (overrideCabal overrides)
    justStaticExecutables
  ]
