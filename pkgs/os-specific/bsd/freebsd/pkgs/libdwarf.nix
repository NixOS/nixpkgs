{ lib, stdenv, mkDerivation
, bsdSetupHook, freebsdSetupHook
, makeMinimal, install, mandoc, groff
, m4
, compatIfNeeded, libelf
}:

mkDerivation {
  path = "lib/libdwarf";
  extraPaths = [
    "contrib/elftoolchain/libdwarf"
    "contrib/elftoolchain/common"
    "sys/sys/elf32.h"
    "sys/sys/elf64.h"
    "sys/sys/elf_common.h"
  ];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal install mandoc groff

    m4
  ];
  buildInputs = compatIfNeeded ++ [
    libelf
  ];
  MK_TESTS = "no";
}
