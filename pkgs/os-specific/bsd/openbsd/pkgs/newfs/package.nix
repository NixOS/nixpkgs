{
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "sbin/newfs";
  extraPaths = [
    "sbin/mount"
    "sbin/disklabel"
  ];
  meta.mainProgram = "newfs";
  meta.platforms = lib.platforms.openbsd;
}
