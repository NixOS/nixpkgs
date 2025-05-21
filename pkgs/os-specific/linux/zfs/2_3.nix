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
  # check the release notes for compatible kernels
  kernelCompatible = kernel: kernel.kernelOlder "6.15";

  # this package should point to the latest release.
  version = "2.3.2";

  tests = {
    inherit (nixosTests.zfs) installer series_2_3;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-+DqpIgHCVi0fDOqvKwaGXIiiXw8xEnlv2tgRwgLX9G8=";
}
