/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" ]
}:

with import ./release-lib.nix {inherit supportedSystems; };

(mapTestOn {
  pypyPackages = packagePlatforms pkgs.pypyPackages;
  pythonPackages = packagePlatforms pkgs.pythonPackages;
  python33Packages = packagePlatforms pkgs.python33Packages;
  python34Packages = packagePlatforms pkgs.python34Packages;
  python35Packages = packagePlatforms pkgs.python35Packages;
})
