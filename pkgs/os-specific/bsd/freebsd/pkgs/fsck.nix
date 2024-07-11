{ mkDerivation }:
mkDerivation {
  path = "sbin/fsck";
  extraPaths = [ "sbin/mount" ];
}
