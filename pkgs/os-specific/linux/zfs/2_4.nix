{
  callPackage,
  lib,
  nixosTests,
  stdenv,
  fetchpatch2,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_4";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.0";

  # this package should point to the latest release.
  version = "2.4.2";

  tests = {
    inherit (nixosTests.zfs) series_2_4;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
    inherit (nixosTests.zfs) installer;
  };

  extraPatches = [
    (fetchpatch2 {
      url = "https://github.com/openzfs/zfs/commit/58c8dc5f6926eb96903a3f38b141e8998ef9261b.diff";
      sha256 = "sha256-ZEhexjy+yWX0CkztdcZva6depjMoqYasClfW4lppZBA=";
    })
  ];

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-OqsKHzyFjjyX8CoajDGydY4TbuQqMA37PIaEOL+vDug=";
}
