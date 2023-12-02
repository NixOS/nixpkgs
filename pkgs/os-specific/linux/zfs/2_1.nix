{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
, lib
, nixosTests
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_1";
  # check the release notes for compatible kernels
  kernelCompatible =
    if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.8"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_7
    else linuxKernel.packages.linux_6_1;

  # This is a fixed version to the 2.1.x series, move only
  # if the 2.1.x series moves.
  version = "2.1.14";
  extraPatches = [
    ./0001-spl-add-shrinker-compatibility-for-6.7.patch
    ./0002-linux-support-new-inode-accessors-for-timestamps.patch
    ./0003-linux-support-the-new-generic_fillattr-with-request-.patch
    ./0004-linux-support-sync_blockdev-instead-of-fsync_bdev-tr.patch
  ];

  hash = "sha256-RVAoZbV9yclGuN+D37SB6UCRFbbLEpBoyrQOQCVsQwE=";

  tests = [
    nixosTests.zfs.series_2_1
  ];

  maintainers = [ lib.maintainers.raitobezarius ];
}
