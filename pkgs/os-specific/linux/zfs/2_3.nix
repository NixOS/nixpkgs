{
  callPackage,
  kernel ? null,
  stdenv,
  lib,
  nixosTests,
  ...
}@args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_3";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "6.12";

  # this package should point to the latest release.
  version = "2.3.0";

  tests = {
    inherit (nixosTests.zfs) installer series_2_3;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-ZWWrVwMP/DSSIxuXp6GuHCD0wiRekHbRXFGaclqd/ns=";
}
