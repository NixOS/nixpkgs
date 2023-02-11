/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ # The platforms for which we build Nixpkgs.
  supportedSystems ? [
    "aarch64-linux"
    "x86_64-linux"
  ]
, # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? { config = { allowUnfree = false; inHydra = true; }; }
}:

with import ./release-lib.nix {inherit supportedSystems nixpkgsArgs; };
with lib;

let
  packagePython = mapAttrs (name: value:
    let res = builtins.tryEval (
      if isDerivation value then
        value.meta.isBuildPythonPackage or []
      else if value.recurseForDerivations or false || value.recurseForRelease or false then
        packagePython value
      else
        []);
    in if res.success then res.value else []
    );

  jobs = {
    lib-tests = import ../../lib/tests/release.nix { inherit pkgs; };
    pkgs-lib-tests = import ../pkgs-lib/tests { inherit pkgs; };

    tested = pkgs.releaseTools.aggregate {
      name = "python-tested";
      meta.description = "Release-critical packages from the python package sets";
      constituents = [
        jobs.remarshal.x86_64-linux                     # Used in pkgs.formats helper
        jobs.python39Packages.buildcatrust.x86_64-linux # Used in pkgs.cacert
        jobs.python39Packages.colorama.x86_64-linux     # Used in nixos test-driver
        jobs.python39Packages.ptpython.x86_64-linux     # Used in nixos test-driver
        jobs.python39Packages.requests.x86_64-linux     # Almost ubiquous package
        jobs.python39Packages.sphinx.x86_64-linux       # Document creation for many packages
      ];
    };

  } // (mapTestOn (packagePython pkgs));
in jobs
