{
  callPackage,
  lib,
  nixosTests,
  stdenv,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_2";
  # check the release notes for compatible kernels
  kernelCompatible = kernel: kernel.kernelOlder "6.18";

  # this package should point to the latest release.
  version = "2.2.9";

  tests = {
    inherit (nixosTests.zfs) series_2_2;
  }
  // lib.optionalAttrs stdenv.isx86_64 {
    inherit (nixosTests.zfs) installer;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-o8rsBtWo4d/gKmMRA1RysPBYZaO8GxQ4rZcJKmgMMsY=";
}
