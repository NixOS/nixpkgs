# Demonstration of incremental builds for Haskell. Useful for speeding up CI.
#
# See: https://www.haskellforall.com/2022/12/nixpkgs-support-for-incremental-haskell.html
# See: https://felixspringer.xyz/homepage/blog/incrementalHaskellBuildsWithNix

{ haskell, haskellPackages, lib }:

let
  inherit (haskell.lib.compose) overrideCabal;

  # Incremental builds work with GHC >=9.4.
  temporary = haskellPackages.temporary;

  # This will do a full build of `temporary`, while writing the intermediate build products
  # (compiled modules, etc.) to the `intermediates` output.
  temporary-full-build-with-incremental-output = overrideCabal (drv: {
    doInstallIntermediates = true;
    enableSeparateIntermediatesOutput = true;
  }) temporary;

  # This will do an incremental build of `temporary` by copying the previously
  # compiled modules and intermediate build products into the source tree
  # before running the build.
  #
  # GHC will then naturally pick up and reuse these products, making this build
  # complete much more quickly than the previous one.
  temporary-incremental-build = overrideCabal (drv: {
    previousIntermediates = temporary-full-build-with-incremental-output.intermediates;
  }) temporary;
in
  temporary-incremental-build.overrideAttrs (old: {
    meta = {
      maintainers = lib.teams.mercury.members;
    };
  })
