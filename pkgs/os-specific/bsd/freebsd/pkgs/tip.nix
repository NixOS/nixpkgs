{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/tip";
  extraPaths = [
    "usr.bin/Makefile.inc"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.platforms = lib.platforms.freebsd;
  meta.mainProgram = "tip";
}
