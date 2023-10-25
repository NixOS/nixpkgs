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
  kernelCompatible =
    if stdenv'.isx86_64 || removeLinuxDRM
    then kernel.kernelOlder "6.4"
    else kernel.kernelOlder "6.2";
  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM then
    linuxKernel.packages.linux_6_3
  else
    linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.1.12";

  sha256 = "eYUR5d4gpTrlFu6j1uL83DWL9uPGgAUDRdSEb73V5i4=";
}
