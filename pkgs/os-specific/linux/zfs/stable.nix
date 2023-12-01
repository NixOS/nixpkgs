{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
, nixosTests
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs";
  # check the release notes for compatible kernels
  kernelCompatible =
    if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.7"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_6
    else linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.2.1";

  hash = "sha256-2Q/Nhp3YKgMCLPNRNBq5r9U4GeuYlWMWAsjsQy3vFW4=";

  extraPatches = [
    ./patches/disable-zfs-dmu-offset-next-sync-by-default-v2-2.patch
  ];

  tests = [
    nixosTests.zfs.installer
    nixosTests.zfs.stable
  ];
}
