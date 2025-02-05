{
  lib,
  mkDerivation,
  versionData,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  flex,
  byacc,
  gencat,
  include,
}:

mkDerivation {
  noLibc = true;
  path = "lib/csu";
  extraPaths = [
    "lib/Makefile.inc"
    "lib/libc/include/libc_private.h"
  ] ++ lib.optionals (versionData.major >= 14) [ "sys/sys/param.h" ];
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    install

    flex
    byacc
    gencat
  ];
  buildInputs = [ include ];
  MK_TESTS = "no";
  meta.platforms = lib.platforms.freebsd;
}
