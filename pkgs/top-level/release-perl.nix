/*
  This is the Hydra jobset for the `perl-updates` branch in Nixpkgs.
  The jobset can be tested by:

  $ hydra-eval-jobs pkgs/top-level/release-perl.nix
*/

{
  supportedSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
}:

let
  inherit (import ./release-lib.nix { inherit supportedSystems; }) mapTestOn packagePlatforms pkgs;

in
mapTestOn { perlPackages = packagePlatforms pkgs.perlPackages; }
