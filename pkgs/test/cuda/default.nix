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
in
lib.recurseIntoAttrs (
  lib.mapAttrs (_: getTests) {
    inherit (pkgs)
      cudaPackages

      cudaPackages_12
      cudaPackages_12_6
      cudaPackages_12_8
      cudaPackages_12_9

      cudaPackages_13
      cudaPackages_13_0
      ;
  }
)
