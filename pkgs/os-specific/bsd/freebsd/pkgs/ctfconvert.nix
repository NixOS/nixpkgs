{ lib, stdenv, mkDerivation
, bsdSetupHook, freebsdSetupHook
, makeMinimal, install, mandoc, groff
, compatIfNeeded, libelf, libdwarf, zlib, libspl
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
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal install mandoc groff

    # flex byacc file2c
  ];
  buildInputs = compatIfNeeded ++ [
    libelf libdwarf zlib libspl
  ];
  meta.license = lib.licenses.cddl;
}
