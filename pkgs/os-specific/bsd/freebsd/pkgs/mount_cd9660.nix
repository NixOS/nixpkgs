{
  lib,
  mkDerivation,
  libkiconv,
}:
mkDerivation {
  path = "sbin/mount_cd9660";
  extraPaths = [ "sbin/mount" ];
  buildInputs = [ libkiconv ];

  meta.platforms = lib.platforms.freebsd;
}

