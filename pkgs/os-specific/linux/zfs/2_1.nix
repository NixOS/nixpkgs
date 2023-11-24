{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
, lib
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
  version = "2.1.13";

  extraPatches = [
    (fetchpatch {
      # https://github.com/openzfs/zfs/pull/15571
      # Remove when it's backported to 2.1.x.
      url = "https://github.com/robn/zfs/commit/617c990a4cf1157b0f8332f35672846ad16ca70a.patch";
      hash = "sha256-j5YSrud7BaWk2npBl31qwFFLYltbut3CUjI1cjZOpag=";
    })
  ];

  hash = "sha256-tqUCn/Hf/eEmyWRQthWQdmTJK2sDspnHiiEfn9rz2Kc=";

  tests = [
    nixosTests.zfs.series_2_1
  ];

  maintainers = [ lib.maintainers.raitobezarius ];
}
