{ lib, mkDerivation }:
mkDerivation {
  path = "sbin/fsck";
  extraPaths = [ "sbin/mount" ];

  meta.platforms = lib.platforms.freebsd;
}
