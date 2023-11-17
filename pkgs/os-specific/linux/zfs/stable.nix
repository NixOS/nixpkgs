{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, removeLinuxDRM ? false
, fetchpatch
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # check the release notes for compatible kernels
  kernelCompatible =
    if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.6"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_5
    else linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.2.0";

  sha256 = "sha256-s1sdXSrLu6uSOmjprbUa4cFsE2Vj7JX5i75e4vRnlvg=";
}
