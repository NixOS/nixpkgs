{
  lib,
  mkDerivation,
  libspl,
  zlib,
}:
mkDerivation {
  path = "cddl/lib/libctf";
  extraPaths = [
    "cddl/contrib/opensolaris/common/ctf"
    "cddl/contrib/opensolaris/lib/libctf/common"

    "sys/contrib/openzfs/include"
    "sys/contrib/openzfs/lib/libspl/include"

    "sys/cddl/compat/opensolaris"
    "cddl/compat/opensolaris/include"

    "sys/contrib/openzfs/include/os/freebsd/spl/sys/ccompile.h"
    "cddl/contrib/opensolaris/head"
    "cddl/contrib/opensolaris/common/ctf"
    "cddl/contrib/opensolaris/lib/libctf/common"
    "sys/cddl/contrib/opensolaris/uts/common"
  ];

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [
    zlib
    libspl
  ];

  preBuild = ''
    export OPENSOLARIS_USR_DISTDIR=$BSDSRCDIR/cddl/contrib/opensolaris
    export OPENSOLARIS_SYS_DISTDIR=$BSDSRCDIR/sys/cddl/contrib/opensolaris
  '';

  MK_WERROR = "no";

  alwaysKeepStatic = true;

  meta.platforms = lib.platforms.freebsd;
}
