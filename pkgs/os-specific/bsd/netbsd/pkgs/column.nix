{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/column";
  meta.platforms = lib.platforms.unix;
}
