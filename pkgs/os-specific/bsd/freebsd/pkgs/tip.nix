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

  meta.mainProgram = "tip";
}
