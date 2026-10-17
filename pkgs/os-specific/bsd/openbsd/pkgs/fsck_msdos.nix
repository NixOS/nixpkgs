{ mkDerivation }:
mkDerivation {
  path = "sbin/fsck_msdos";
  extraPaths = [ "sbin/fsck" ];
}
