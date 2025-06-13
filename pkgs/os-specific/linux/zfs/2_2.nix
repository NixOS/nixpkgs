{
  callPackage,
  lib,
  nixosTests,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_2";
  # check the release notes for compatible kernels
  kernelCompatible = kernel: kernel.kernelOlder "6.16";

  # this package should point to the latest release.
  version = "2.2.8";

  tests = {
    inherit (nixosTests.zfs) installer series_2_2;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-ZYgC8L4iI9ewaC7rkMFSRAKeTWr72N5aRP98VLL4oqo=";
}
