# Run
#
#   nix-build test-evaluation.nix --dry-run
#
# to test whether the R package set evaluates properly.

let

  config = {
    allowBroken = true;
    allowUnfree = true;
  };

  inherit (import ../../.. { inherit config; }) pkgs;

  rWrapper = pkgs.rWrapper.override {
    packages = pkgs.lib.filter pkgs.lib.isDerivation (pkgs.lib.attrValues pkgs.rPackages);
  };

in
rWrapper
