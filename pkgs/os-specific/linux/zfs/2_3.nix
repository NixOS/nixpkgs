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
  kernelModuleAttribute = "zfs_2_3";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "6.17";

  # this package should point to the latest release.
  version = "2.3.5";

  extraPatches = [
    (fetchpatch {
      name = "fix_llvm-21_-wuninitialized-const-pointer_warning.patch";
      url = "https://github.com/openzfs/zfs/commit/9acedbaceec362d08a33ebfe7c4c7efcee81d094.patch";
      hash = "sha256-bjMRuT8gsMuwCnrS5PfG9vYthRvcFaWCCfQbCTVZdpw=";
    })
  ];

  tests = {
    inherit (nixosTests.zfs) series_2_3;
  }
  // lib.optionalAttrs stdenv.isx86_64 {
    inherit (nixosTests.zfs) installer;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-zTDdoQWbguKeWjQH5+FOTDhxfs3e7UPFnUX8ZugHQy4=";
}
