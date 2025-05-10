{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "sbin/mknod";
  meta.platforms = lib.platforms.unix;
}
