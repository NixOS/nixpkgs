{ lib, mkDerivation }:
mkDerivation {
  path = "sbin/fsck_msdosfs";
  extraPaths = [
    "sbin/mount"
    "sbin/fsck"
  ];

  meta.platforms = lib.platforms.freebsd;
}
