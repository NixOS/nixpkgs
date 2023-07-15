{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # check the release notes for compatible kernels
  # NOTE:
  #   zfs-2.1.9<=x<=2.1.10 is broken with aarch64-linux-6.2
  #   for future releases, please delete this condition.
  kernelCompatible = if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.4"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM then
    linuxKernel.packages.linux_6_3
  else
    linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.1.12";

  sha256 = "eYUR5d4gpTrlFu6j1uL83DWL9uPGgAUDRdSEb73V5i4=";

  isUnstable = true;
}
