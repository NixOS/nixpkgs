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

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_4
    else linuxKernel.packages.linux_6_1;

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.1.13-unstable-2023-08-02";
  rev = "245850b66c1e93ec19744ca55aae143d007d2c32";

  sha256 = "TtgKV02W8OfU6hssULF/IoFXAPHBTvTKXn5hJ/RGAc0=";

  isUnstable = true;
}
