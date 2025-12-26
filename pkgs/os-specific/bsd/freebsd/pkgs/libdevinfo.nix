{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libdevinfo";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.platforms = lib.platforms.freebsd;
}
