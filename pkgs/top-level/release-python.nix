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
      allowAliases = false;
      allowUnfree = false;
      inHydra = true;
    };

    __allowFileset = false;
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
        else if value.recurseForDerivations or false || value.recurseForRelease or false then
          packagePython value
        else
          [ ]
      );
    in
    optionals res.success res.value
  );

  jobs = {
    # for pkgs.formats tests, which rely on remarshal
    pkgs-lib-tests = import ../pkgs-lib/tests { inherit pkgs; };

    tested = pkgs.releaseTools.aggregate {
      name = "python-tested";
      meta.description = "Release-critical packages from the python package sets";
      constituents = [
        jobs.nixos-render-docs.x86_64-linux # Used in nixos manual
        jobs.remarshal.x86_64-linux # Used in pkgs.formats.yaml_1_1
        jobs.python314Packages.afdko.x86_64-linux # Used in noto-fonts-color-emoji
        jobs.python314Packages.buildcatrust.x86_64-linux # Used in pkgs.cacert
        jobs.python314Packages.colorama.x86_64-linux # Used in nixos test-driver
        jobs.python314Packages.ptpython.x86_64-linux # Used in nixos test-driver
        jobs.python314Packages.requests.x86_64-linux # Almost ubiquitous package
        jobs.python314Packages.sphinx.x86_64-linux # Document creation for many packages
      ];
    };

  }
  // (mapTestOn (packagePython pkgs));
in
jobs
