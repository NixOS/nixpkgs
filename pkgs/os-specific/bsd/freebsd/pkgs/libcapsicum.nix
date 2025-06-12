{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libcapsicum";
  meta.platforms = lib.platforms.unix;
}
