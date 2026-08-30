{ mkDerivation, mknod }:

mkDerivation {
  path = "usr.sbin/mtree";
  extraPaths = [ mknod.path ];
}
