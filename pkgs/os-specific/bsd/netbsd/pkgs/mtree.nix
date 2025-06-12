{
  lib,
  mkDerivation,
  mknod,
}:
mkDerivation {
  path = "usr.sbin/mtree";
  extraPaths = [ mknod.path ];

  meta.platforms = lib.platforms.unix;
}
