{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/getconf";
  meta.platforms = lib.platforms.unix;
}
