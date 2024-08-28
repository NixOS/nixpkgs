{ callPackage
, kernel ? null
, stdenv
, lib
, linuxKernel
, nixosTests
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_2";
  # check the release notes for compatible kernels
  kernelCompatible = kernel.kernelOlder "6.10";

  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_6;

  # this package should point to the latest release.
  version = "2.2.5";

  tests = [
    nixosTests.zfs.installer
    nixosTests.zfs.series_2_2
  ];

  maintainers = with lib.maintainers; [ adamcstephens amarshall ];

  hash = "sha256-BkwcNPk+jX8CXp5xEVrg4THof7o/5j8RY2SY6+IPNTg=";
}
