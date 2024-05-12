{
  lib,
  mkDerivation,
  compatIfNeeded,
  libdwarf,
  zlib,
  libspl,
}:

mkDerivation {
  path = "cddl/usr.bin/ctfconvert";
  extraPaths = [
    "cddl/compat/opensolaris"
    "cddl/contrib/opensolaris"
    "sys/cddl/compat/opensolaris"
    "sys/cddl/contrib/opensolaris"
    "sys/contrib/openzfs"
  ];
  OPENSOLARIS_USR_DISTDIR = "$(SRCTOP)/cddl/contrib/opensolaris";
  OPENSOLARIS_SYS_DISTDIR = "$(SRCTOP)/sys/cddl/contrib/opensolaris";

  makeFlags = [
    "STRIP=-s"
    "MK_WERROR=no"
    "MK_TESTS=no"
  ];

  buildInputs = compatIfNeeded ++ [
    libdwarf
    zlib
    libspl
  ];

  meta.license = lib.licenses.cddl;
}
