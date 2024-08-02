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

  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_9;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.4-unstable-2024-07-15";
  rev = "/54ef0fdf60a8e7633c38cb46e1f5bcfcec792f4e";

  isUnstable = true;
  tests = [
    nixosTests.zfs.unstable
  ];

  # 6.10 patches approved+merged to the default branch, not in staging yet
  # https://github.com/openzfs/zfs/pull/16250
  extraPatches = [
    (fetchpatch {
      url = "https://github.com/openzfs/zfs/commit/7ca7bb7fd723a91366ce767aea53c4f5c2d65afb.patch";
      hash = "sha256-vUX4lgywh5ox6DjtIfeC90KjbLoW3Ol0rK/L65jOENo=";
    })
    (fetchpatch {
      url = "https://github.com/openzfs/zfs/commit/e951dba48a6330aca9c161c50189f6974e6877f0.patch";
      hash = "sha256-A1h0ZLY+nlReBMTlEm3O9kwBqto1cgsZdnJsHpR6hw0=";
    })
    (fetchpatch {
      url = "https://github.com/openzfs/zfs/commit/b409892ae5028965a6fe98dde1346594807e6e45.patch";
      hash = "sha256-pW1b8ktglFhwVRapTB5th9UCyjyrPmCVPg53nMENax8=";
    })

  ];

  hash = "sha256-7vZeIzA2yDW/gSCcS2AM3+C9qbRIbA9XbCRUxikW2+M=";
}
