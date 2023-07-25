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
    then kernel.kernelOlder "6.5"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM then
    linuxKernel.packages.linux_6_4
  else
    linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.0-rc2";

  sha256 = "rOgIp8ZvagPM2JVEPTdNInMd1jNsiHtEtGQvC317R0w=";

  isUnstable = true;
}
