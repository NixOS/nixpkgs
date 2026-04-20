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
  kernelMaxSupportedMajorMinor = "6.19";

  # this package should point to the latest release.
  version = "2.4.1";

  tests = {
    inherit (nixosTests.zfs) series_2_4;
  }
  // lib.optionalAttrs stdenv.isx86_64 {
    inherit (nixosTests.zfs) installer;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-gapM2PNVOjhwGw6TAZF6QDxLza7oqOf1tpj7q0EN9Vg=";
}
