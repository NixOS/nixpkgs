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
    then kernel.kernelOlder "6.7"
    else kernel.kernelOlder "6.2";

  latestCompatibleLinuxPackages = if stdenv'.isx86_64 || removeLinuxDRM
    then linuxKernel.packages.linux_6_6
    else linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.2.1";

  sha256 = "sha256-2Q/Nhp3YKgMCLPNRNBq5r9U4GeuYlWMWAsjsQy3vFW4=";
}
