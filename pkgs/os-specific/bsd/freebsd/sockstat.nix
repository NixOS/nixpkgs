{ mkDerivation, libjail, libcasper, libcapsicum, ... }:
mkDerivation {
  path = "usr.bin/sockstat";
  buildInputs = [
    libjail
    libcasper
    libcapsicum
  ];
  clangFixup = true;
}
