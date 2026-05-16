{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/fstat";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.mainProgram = "fstat";
  meta.platforms = lib.platforms.freebsd;
}
