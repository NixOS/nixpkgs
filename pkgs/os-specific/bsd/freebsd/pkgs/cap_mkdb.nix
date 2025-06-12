{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/cap_mkdb";
  MK_TESTS = "no";

  meta.platforms = lib.platforms.unix;
}
