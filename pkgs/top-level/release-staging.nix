# This file defines the builds that are run for the `staging` branch.
#
# This should be kept minimal to avoid unnecessary load on Hydra; the
# point is not to duplicate `staging-next`, but to catch basic issues
# early and make bisection less painful.

{
  # The platform doubles for which we build Nixpkgs.
  supportedSystems ? [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ],
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? {
    config = {
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

  inherit (release-lib)
    all
    linux
    mapTestOn
    ;
in
mapTestOn {
  stdenv = all;
  cargo = linux;
}
