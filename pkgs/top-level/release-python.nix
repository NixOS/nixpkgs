/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" "i686-linux" "x86_64-darwin" ]
}:

with import ./release-lib.nix {inherit supportedSystems; };

(mapTestOn {
  pypyPackages = packagePlatforms pkgs.pypyPackages;
  pythonPackages = packagePlatforms pkgs.pythonPackages;
  python34Packages = packagePlatforms pkgs.python34Packages;
  python33Packages = packagePlatforms pkgs.python33Packages;
})
