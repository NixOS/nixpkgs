{
  mkDerivation,
}:
mkDerivation {
  path = "lib/libpe";
  extraPaths = [
    "contrib/elftoolchain"
    "sys/sys/elf_common.h"
  ];

  postPatch = ''
    sed -E -i -e '/INTERNALLIB/d' lib/libpe/Makefile
  '';

  alwaysKeepStatic = true;
}
