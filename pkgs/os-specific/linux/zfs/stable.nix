{ callPackage
, kernel ? null
, stdenv
, linuxKernel
, ...
} @ args:

let
  stdenv' = if kernel == null then stdenv else kernel.stdenv;
in
callPackage ./generic.nix args {
  # check the release notes for compatible kernels
  kernelCompatible =
    if stdenv'.isx86_64
    then kernel.kernelOlder "6.3"
    else kernel.kernelOlder "6.2";
  latestCompatibleLinuxPackages = linuxKernel.packages.linux_6_1;

  # this package should point to the latest release.
  version = "2.1.11";

  sha256 = "tJLwyqUj1l5F0WKZDeMGrEFa8fc/axKqm31xtN51a5M=";
}
