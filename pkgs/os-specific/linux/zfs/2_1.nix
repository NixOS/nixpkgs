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
    then kernel.kernelOlder "6.6"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_5
    else linuxKernel.packages.linux_6_1;

  # This is a fixed version to the 2.1.x series, move only
  # if the 2.1.x series moves.
  version = "2.1.14";

  hash = "sha256-RVAoZbV9yclGuN+D37SB6UCRFbbLEpBoyrQOQCVsQwE=";

  tests = [
    nixosTests.zfs.series_2_1
  ];

  maintainers = [ lib.maintainers.raitobezarius ];
}
