{ lib, stdenv, mkDerivation
, bsdSetupHook, freebsdSetupHook
, makeMinimal, install, mandoc, groff
, m4
}:

mkDerivation {
  path = "lib/libelf";
  extraPaths = [
    "contrib/elftoolchain/libelf"
    "contrib/elftoolchain/common"
    "sys/sys/elf32.h"
    "sys/sys/elf64.h"
    "sys/sys/elf_common.h"
  ];
  BOOTSTRAPPING = !stdenv.isFreeBSD;
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal install mandoc groff

    m4
  ];
  MK_TESTS = "no";
}
