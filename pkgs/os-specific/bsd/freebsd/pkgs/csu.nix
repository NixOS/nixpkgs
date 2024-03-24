{ lib, mkDerivation
, bsdSetupHook, freebsdSetupHook
, makeMinimal
, install
, flex, byacc, gencat
, include
}:

mkDerivation {
  path = "lib/csu";
  extraPaths = [
    "lib/Makefile.inc"
    "lib/libc/include/libc_private.h"
  ];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal
    install

    flex byacc gencat
  ];
  buildInputs = [ include ];
  MK_TESTS = "no";
  meta.platforms = lib.platforms.freebsd;
}
