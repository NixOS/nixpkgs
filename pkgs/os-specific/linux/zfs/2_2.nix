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
  kernelModuleAttribute = "zfs_2_2";
  # check the release notes for compatible kernels
  kernelCompatible = kernel: kernel.kernelOlder "6.13";

  # this package should point to the latest release.
  version = "2.2.7";

  tests = {
    inherit (nixosTests.zfs) installer series_2_2;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-nFOB0/7YK4e8ODoW9A+RQDkZHG/isp2EBOE48zTaMP4=";
}
