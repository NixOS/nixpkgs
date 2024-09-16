{ callPackage
, kernel ? null
, stdenv
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
  kernelCompatible = kernel: kernel.kernelOlder "6.8";

  # This is a fixed version to the 2.1.x series, move only
  # if the 2.1.x series moves.
  version = "2.1.15";

  hash = "sha256-zFO8fMbirEOrn5W57rAN7IWY6EIXG8jDXqhP7BWJyiY=";

  tests = [
    nixosTests.zfs.series_2_1
  ];

  maintainers = [ lib.maintainers.raitobezarius ];
}
