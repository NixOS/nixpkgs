{
  callPackage,
  lib,
  nixosTests,
  stdenv,
  fetchpatch,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_4";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.0";

  # this package should point to the latest release.
  version = "2.4.3";

  extraPatches = [
    # https://github.com/openzfs/zfs/issues/18366
    # dedup data corruption fix unreleased as of OpenZFS 2.4.3
    (fetchpatch {
      url = "https://github.com/openzfs/zfs/commit/6fb72fda0f60d9efb591e320f83f78b19ec451cc.patch?full_index=1";
      hash = "sha256-UuSVmO61Ux5S3F+JAtRnHyeVS4EFobDTKBuD5s8PI+k=";
    })
  ];

  tests = {
    inherit (nixosTests.zfs) series_2_4;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
    inherit (nixosTests.zfs) installer;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-I1wLbstr0cFiGsyynP9kJ9ATRp/2b+fnnsdz0up+IzM=";
}
