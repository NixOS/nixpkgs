{
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "sbin/newfs_msdos";
  meta.mainProgram = "newfs_msdos";
  meta.platforms = lib.platforms.openbsd;
}
