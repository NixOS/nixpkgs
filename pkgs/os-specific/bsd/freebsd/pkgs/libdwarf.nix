{
  mkDerivation,
  m4,
  compatIfNeeded,
  zlib,
  libelf,
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
  extraNativeBuildInputs = [ m4 ];
  buildInputs = compatIfNeeded ++ [
    zlib
    libelf
  ];
  MK_TESTS = "no";
}
