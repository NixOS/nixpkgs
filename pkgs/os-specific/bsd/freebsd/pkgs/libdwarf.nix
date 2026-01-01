{
  mkDerivation,
  m4,
  compatIfNeeded,
  zlib,
<<<<<<< HEAD
  libelf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  buildInputs = compatIfNeeded ++ [
    zlib
    libelf
  ];
=======
  buildInputs = compatIfNeeded ++ [ zlib ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  MK_TESTS = "no";
}
