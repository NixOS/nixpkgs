{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, nixosTests
, fetchpatch
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_unstable";
  # check the release notes for compatible kernels
  kernelCompatible = kernel.kernelOlder "6.11";

  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_10;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.5";
  # rev = "";

  isUnstable = true;
  tests = [
    nixosTests.zfs.unstable
  ];

  hash = "sha256-BkwcNPk+jX8CXp5xEVrg4THof7o/5j8RY2SY6+IPNTg=";
}
