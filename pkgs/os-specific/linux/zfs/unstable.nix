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
  kernelCompatible = if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.5"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.2.0-rc4";

  sha256 = "sha256-zTG6iujlWB2H8j6i+t59zdyztoDFk373AjgHzC8x5mQ=";

  isUnstable = true;
}
