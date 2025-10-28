{
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "sbin/umount";
  meta.mainProgram = "ummount";
  meta.platforms = lib.platforms.openbsd;
}
