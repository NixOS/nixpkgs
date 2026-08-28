{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "sbin/mount_nullfs";
  extraPaths = [ "sbin/mount" ];

}
