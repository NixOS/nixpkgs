{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "sbin/rcorder";
  meta.platforms = lib.platforms.unix;
}
