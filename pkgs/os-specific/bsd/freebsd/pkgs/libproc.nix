{
  lib,
  mkDerivation,
  libctf,
  librtld-db,
  zlib,
}:
mkDerivation {
  path = "lib/libproc";
  extraPaths = [
    "sys/contrib/openzfs/include"
    "sys/contrib/openzfs/lib/libspl/include"
    "sys/contrib/openzfs/lib/libspl/include"
    "sys/contrib/openzfs/include/os/freebsd/spl/sys/ccompile.h"
    "cddl/contrib/opensolaris/lib/libctf/common"
    "sys/cddl/contrib/opensolaris/uts/common"
    "sys/cddl/compat/opensolaris"
  ];

  buildInputs = [
    libctf
    librtld-db
    zlib
  ];

  outputs = [
    "out"
    "debug"
  ];

  MK_TESTS = "no";

  meta.platforms = lib.platforms.freebsd;
}
