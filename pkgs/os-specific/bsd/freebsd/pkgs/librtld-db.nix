{
  lib,
  mkDerivation,
  libelf,
  libprocstat,
}:
mkDerivation {
  path = "lib/librtld_db";
  extraPaths = [
    "lib/libproc/libproc.h"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  buildInputs = [
    libelf
    libprocstat
  ];

  meta.platforms = lib.platforms.freebsd;
}
