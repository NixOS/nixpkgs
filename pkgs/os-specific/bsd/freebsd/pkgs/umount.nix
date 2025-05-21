{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "sbin/umount";
  extraPaths = [
    "sbin/mount"
    "usr.sbin/rpc.umntall"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.platforms = lib.platforms.freebsd;
}
