{
  callPackage,
  lib,
  nixosTests,
  stdenv,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_3";
  # check the release notes for compatible kernels
  kernelCompatible = kernel: kernel.kernelOlder "6.16";

  # this package should point to the latest release.
  version = "2.3.3";

  tests =
    {
      inherit (nixosTests.zfs) series_2_3;
    }
    // lib.optionalAttrs stdenv.isx86_64 {
      inherit (nixosTests.zfs) installer;
    };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-NXAbyGBfpzWfm4NaP1/otTx8fOnoRV17343qUMdQp5U=";
}
