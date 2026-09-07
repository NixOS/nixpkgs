{
  lib,
  mkDerivation,
  buildPackages,
}:
mkDerivation {
  path = "lib/libcurses";

  makeFlags = [
    "AWK=${lib.getBin buildPackages.gawk}/bin/awk"
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ];
}
