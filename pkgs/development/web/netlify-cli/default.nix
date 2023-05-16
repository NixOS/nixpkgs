{ callPackage, fetchFromGitHub, lib, pkgs }:
let
  nodePackages = import ./composition.nix { inherit pkgs; };
  sourceInfo = (lib.importJSON ./netlify-cli.json);
in
  nodePackages.package.override {
    preRebuild = ''
      export ESBUILD_BINARY_PATH="${pkgs.esbuild_netlify}/bin/esbuild"
    '';
    src = fetchFromGitHub {
<<<<<<< HEAD
      inherit (sourceInfo) owner repo rev hash;
=======
      inherit (sourceInfo) owner repo rev sha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
    bypassCache = true;
    reconstructLock = true;
    passthru.tests.test = callPackage ./test.nix { };
    meta.maintainers = with lib.maintainers; [ roberth ];
  }
