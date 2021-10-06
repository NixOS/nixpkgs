/*
  This is the Hydra jobset for the `r-updates` branch in Nixpkgs.
  The jobset can be tested by:

  $ hydra-eval-jobs -I . pkgs/top-level/release-r.nix
*/
{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ] }:

with import ./release-lib.nix { inherit supportedSystems; };

mapTestOn {
  rPackages = packagePlatforms pkgs.rPackages;
}
