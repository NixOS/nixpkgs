# cd nixpkgs
# nix-build -A tests.pkg-config
{ lib, stdenv, ... }:

let
  # defaultPkgConfigPackages test needs a Nixpkgs with allowUnsupportedPlatform
  # in order to filter out the unsupported packages without throwing any errors
  # tryEval would be too fragile, masking different problems as if they're
  # unsupported platform problems.
  allPkgs = import ../default.nix {
    system = stdenv.hostPlatform.system;
<<<<<<< HEAD
    localSystem = stdenv.buildPlatform.system;
=======
    localSystem = stdenv.hostPlatform.system;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    config = {
      allowUnsupportedSystem = true;
    };
    overlays = [];
  };
in
lib.recurseIntoAttrs {
  defaultPkgConfigPackages = allPkgs.callPackage ./test-defaultPkgConfigPackages.nix { };
}
