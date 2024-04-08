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
  kernelCompatible = kernel.kernelOlder "6.8";

  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_6;

  # this package should point to the latest release.
  version = "2.2.3";

  tests = [
    nixosTests.zfs.installer
    nixosTests.zfs.stable
  ];

  hash = "sha256-Bzkow15OitUUQ+mTYhCXgTrQl+ao/B4feleHY/rSSjg=";
}
