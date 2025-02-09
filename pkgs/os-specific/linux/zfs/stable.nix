{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
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
  kernelCompatible =
    if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.7"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_6
    else linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.2.2";

  tests = [
    nixosTests.zfs.installer
    nixosTests.zfs.stable
  ];

  hash = "sha256-CqhETAwhWMhbld5ib3Rz1dxms+GQbLwjEZw/V7U/2nE=";
}
