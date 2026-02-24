{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libdevdctl";
  clangFixup = false;

  outputs = [
    "out"
    "debug"
  ];

  meta.platforms = lib.platforms.freebsd;
}
