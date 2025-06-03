{
  mkDerivation,
}:

mkDerivation {
  path = "sbin/mount_tmpfs";
  extraPaths = [ "sbin/mount" ];
}
