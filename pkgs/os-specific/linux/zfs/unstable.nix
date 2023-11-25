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
  kernelCompatible = if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.6"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_5
    else linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.1-unstable-2023-10-21";
  rev = "95785196f26e92d82cf4445654ba84e4a9671c57";

  hash = "sha256-s1sdXSrLu6uSOmjprbUa4cFsE2Vj7JX5i75e4vRnlvg=";

  isUnstable = true;
  tests = [
    nixosTests.zfs.unstable
  ];
}
