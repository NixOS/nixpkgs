{
  mkDerivation,
  lib,
  libgeom,
  libzfs,
  libdevdctl,
  libsbuf,
  libbsdxml,
}:
mkDerivation {
  path = "cddl/usr.sbin/zfsd";
  extraPaths = [
    "sys/contrib/openzfs"
  ];
  clangFixup = false;
  ouptuts = [
    "out"
    "man"
    "debug"
  ];

  buildInputs = [
    libgeom
    libzfs
    libdevdctl
    libsbuf
    libbsdxml
  ];

  MK_TESTS = "no";

  env.NIX_CFLAGS_COMPILE = "-std=c++23 -Wno-nullability-completeness";

  meta = {
    mainProgram = "zfsd";
    platforms = lib.platforms.freebsd;
    license = with lib.licenses; [
      cddl
      bsd2
    ];
  };
}
