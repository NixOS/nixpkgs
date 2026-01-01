{
  lib,
  mkDerivation,
  compatIfNeeded,
  libdwarf,
<<<<<<< HEAD
  libelf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    libelf
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta.license = lib.licenses.cddl;
}
