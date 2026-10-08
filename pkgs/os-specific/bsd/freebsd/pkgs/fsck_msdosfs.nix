{ lib, mkDerivation }:
mkDerivation {
  path = "sbin/fsck_msdosfs";
  extraPaths = [
    "sbin/mount"
    "sbin/fsck"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-unterminated-string-initialization"
  ];

  meta.platforms = lib.platforms.freebsd;
}
