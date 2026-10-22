{
  mkDerivation,
}:

mkDerivation {
  path = "sbin/mount_ffs";
  extraPaths = [ "sbin/mount" ];
}
