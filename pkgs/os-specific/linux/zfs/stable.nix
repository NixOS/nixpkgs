{ callPackage
, kernel ? null
, stdenv
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
  kernelModuleAttribute = "zfs";
  # check the release notes for compatible kernels
  kernelCompatible = kernel.kernelOlder "6.9";

  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_8;

  # this package should point to the latest release.
  version = "2.2.4";

  tests = [
    nixosTests.zfs.installer
    nixosTests.zfs.stable
  ];

  hash = "sha256-SSp/1Tu1iGx5UDcG4j0k2fnYxK05cdE8gzfSn8DU5Z4=";
}
