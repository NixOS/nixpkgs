{ mkDerivation, libkiconv }:
mkDerivation {
  path = "sbin/mount_msdosfs";
  extraPaths = [ "sbin/mount" ];
  buildInputs = [ libkiconv ];
}
