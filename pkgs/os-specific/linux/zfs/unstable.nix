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
  kernelModuleAttribute = "zfsUnstable";
  # check the release notes for compatible kernels
  kernelCompatible =
    if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.8"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_7
    else linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.3-unstable-2024-01-26";
  rev = "3425484eb907d489c315cced2a1fdea08ef03fc4";

  isUnstable = true;
  tests = [
    nixosTests.zfs.unstable
  ];

  hash = "sha256-P8PIp0qRHm/fxYdxWKVRX9LR5tKZR7fFUSY90QDE/lU=";
}
