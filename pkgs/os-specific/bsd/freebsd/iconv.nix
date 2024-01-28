{ mkDerivation, lib, stdenv, libcapsicum, libcasper, ...}:
mkDerivation {
  path = "usr.bin/iconv";
  buildInputs = [libcapsicum libcasper];

  clangFixup = true;
}
