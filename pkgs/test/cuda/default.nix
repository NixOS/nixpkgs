{
  lib,
  pkgs,
}:
let
  getTests =
    cps:
    lib.recurseIntoAttrs {
      inherit (cps) saxpy;
      inherit (cps.tests) cuda-library-samples;
    };

  # backendStdenv throws when a package set cannot target the configured CUDA capabilities.
  supportsConfiguredCapabilities = _: cps: (builtins.tryEval cps.backendStdenv).success;
in
lib.recurseIntoAttrs (
  lib.mapAttrs (_: getTests) (
    {
      inherit (pkgs) cudaPackages;
    }
    // lib.filterAttrs supportsConfiguredCapabilities {
      inherit (pkgs)
        cudaPackages_12
        cudaPackages_12_6
        cudaPackages_12_8
        cudaPackages_12_9

        cudaPackages_13
        cudaPackages_13_0
        ;
    }
  )
)
