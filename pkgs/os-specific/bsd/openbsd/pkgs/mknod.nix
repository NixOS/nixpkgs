{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "sbin/mknod";
  meta.mainProgram = "mknod";
  meta.platforms = lib.platforms.openbsd;
}
