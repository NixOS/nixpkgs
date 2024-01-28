{ lib, stdenv, mkDerivation, libkiconv, ... }:
mkDerivation {
  path = "sbin/mount_msdosfs";
  extraPaths = [ "sbin/mount" ];

  buildInputs = [ libkiconv ];

  clangFixup = true;
}
