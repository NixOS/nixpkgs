{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/file2c";
  MK_TESTS = "no";

  meta.platforms = lib.platforms.unix;
}
