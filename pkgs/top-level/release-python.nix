/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{
  # The platforms for which we build Nixpkgs.
  supportedSystems ? [
    "aarch64-linux"
    "x86_64-linux"
  ],
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? {
    config = {
      allowUnfree = false;
      inHydra = true;
      permittedInsecurePackages = [
        # Keep evaluating home-assistant, which is transitively affected
        # by home-assistant-chip-core consuming OpenSSL 1.1. Affects roughly
        # 800 jobs.
        "openssl-1.1.1w"
      ];
    };
  },
}:

let
  release-lib = import ./release-lib.nix {
    inherit supportedSystems nixpkgsArgs;
  };

  inherit (release-lib) mapTestOn pkgs;

  inherit (release-lib.lib) isDerivation mapAttrs optionals;

  packagePython = mapAttrs (
    name: value:
    let
      res = builtins.tryEval (
        if isDerivation value then
          value.meta.isBuildPythonPackage or [ ]
        else if
          value.recurseForDerivations or false
          || value.recurseForRelease or false
          || value.__recurseIntoDerivationForReleaseJobs or false
        then
          packagePython value
        else
          [ ]
      );
    in
    optionals res.success res.value
  );

  jobs = {
    lib-tests = import ../../lib/tests/release.nix { inherit pkgs; };
    pkgs-lib-tests = import ../pkgs-lib/tests { inherit pkgs; };

    tested = pkgs.releaseTools.aggregate {
      name = "python-tested";
      meta.description = "Release-critical packages from the python package sets";
      constituents = [
        jobs.nixos-render-docs.x86_64-linux # Used in nixos manual
        jobs.remarshal.x86_64-linux # Used in pkgs.formats helper
        jobs.python311Packages.buildcatrust.x86_64-linux # Used in pkgs.cacert
        jobs.python311Packages.colorama.x86_64-linux # Used in nixos test-driver
        jobs.python311Packages.ptpython.x86_64-linux # Used in nixos test-driver
        jobs.python311Packages.requests.x86_64-linux # Almost ubiquous package
        jobs.python311Packages.sphinx.x86_64-linux # Document creation for many packages
      ];
    };

  } // (mapTestOn (packagePython pkgs));
in
jobs
