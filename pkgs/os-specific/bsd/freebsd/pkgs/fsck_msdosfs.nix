{ lib, mkDerivation }:
mkDerivation {
  path = "sbin/fsck_msdosfs";
  extraPaths = [
    "sbin/mount"
    "sbin/fsck"
  ];

<<<<<<< HEAD
  NIX_CFLAGS_COMPILE = [
    "-Wno-unterminated-string-initialization"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta.platforms = lib.platforms.freebsd;
}
