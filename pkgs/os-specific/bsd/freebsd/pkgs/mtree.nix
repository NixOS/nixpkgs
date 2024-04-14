{ mkDerivation, mknod }:

mkDerivation {
  path = "contrib/mtree";
  extraPaths = [ mknod.path ];
}
