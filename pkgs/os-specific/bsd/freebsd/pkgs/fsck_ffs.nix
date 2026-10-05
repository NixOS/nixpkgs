{
  lib,
  mkDerivation,
  libufs,
}:
mkDerivation {
  path = "sbin/fsck_ffs";
  extraPaths = [ "sbin/mount" ];

  buildInputs = [ libufs ];

}
