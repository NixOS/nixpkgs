{ mkDerivation, buildPackages, buildFreebsd, include, lib, ... }:
mkDerivation {
  isStatic = true;
  path = "lib/csu";
  extraPaths = [
    "lib/Makefile.inc"
    "lib/libc/include/libc_private.h"
  ];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install

    buildPackages.flex buildPackages.byacc buildFreebsd.gencat
  ];
  buildInputs = [ include ];
  MK_TESTS = "no";
  meta.platforms = lib.platforms.freebsd;
}
