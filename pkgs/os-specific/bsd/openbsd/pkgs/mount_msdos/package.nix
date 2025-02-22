{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "sbin/mount_msdos";
  extraPaths = [
    "sbin/mount"
  ];
  meta.mainProgram = "mount_msdos";
  meta.platforms = lib.platforms.openbsd;
}
