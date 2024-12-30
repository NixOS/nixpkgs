{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/gencat";
  meta.platforms = lib.platforms.unix;
}
