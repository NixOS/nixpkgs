{
  mkDerivation,
  compatIfNeeded,
  libelf,
  libelftc,
  libarchive,
  libpe,
}:

mkDerivation {
  path = "usr.bin/elfcopy";
  extraPaths = [
    "contrib/elftoolchain"
    "sys/sys/elf_common.h"
    "sys/sys/elf32.h"
  ];

  buildInputs = compatIfNeeded ++ [
    libelf
    libelftc
    libarchive
    libpe
  ];

  # since we built libpe and co separate they are not internal and thus not pie...?
  MK_PIE = "no";
}
