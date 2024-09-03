{
  lib,
  mkDerivation,
  libkiconv,
}:
mkDerivation {
  path = "sbin/mount_msdosfs";
  extraPaths = [ "sbin/mount" ];
  buildInputs = [ libkiconv ];

  meta.platforms = lib.platforms.freebsd;
}
