{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/bintrans";
  MK_TESTS = "no";

  meta.platforms = lib.platforms.unix;
}
