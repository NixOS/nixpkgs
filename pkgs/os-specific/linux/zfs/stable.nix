{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
, fetchpatch
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
    then kernel.kernelOlder "6.6"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_5
    else linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.2.0";

  tests = [
    nixosTests.zfs.installer
    nixosTests.zfs.stable
  ];

  hash = "sha256-s1sdXSrLu6uSOmjprbUa4cFsE2Vj7JX5i75e4vRnlvg=";
}
