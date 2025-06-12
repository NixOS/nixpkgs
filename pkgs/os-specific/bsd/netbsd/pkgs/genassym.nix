{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/genassym";
  meta.platforms = lib.platforms.unix;
}
