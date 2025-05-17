{
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "usr.bin/sed";
  MK_TESTS = "no";

  meta.platforms = lib.platforms.unix;
}
