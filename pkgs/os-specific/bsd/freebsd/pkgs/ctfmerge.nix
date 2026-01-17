{
  lib,
  mkDerivation,
  compatIfNeeded,
  libelf,
  zlib,
  libspl,
}:

mkDerivation {
  path = "cddl/usr.bin/ctfmerge";
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
    zlib
    libspl
    libelf
  ];

  meta.license = lib.licenses.cddl;
}
