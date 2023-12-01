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
  kernelModuleAttribute = "zfsUnstable";
  # check the release notes for compatible kernels
  kernelCompatible = if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.7"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_6
    else linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.1";

  hash = "sha256-2Q/Nhp3YKgMCLPNRNBq5r9U4GeuYlWMWAsjsQy3vFW4=";

  isUnstable = true;

  extraPatches = [
    ./patches/disable-zfs-dmu-offset-next-sync-by-default-v2-2.patch
  ];

  tests = [
    nixosTests.zfs.unstable
  ];
}
