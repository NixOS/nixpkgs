{
  mkDerivation,
  libelf,
  compatIfNeeded,
}:
mkDerivation {
  path = "lib/libelftc";
  extraPaths = [
    "contrib/elftoolchain"
    "sys/sys/elf_common.h"
  ];

  buildInputs = compatIfNeeded ++ [
    libelf
  ];

  postPatch = ''
    sed -E -i -e '/INTERNALLIB/d' lib/libelftc/Makefile
  '';

  alwaysKeepStatic = true;
}
