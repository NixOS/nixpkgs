{ mkDerivation, lib, stdenv, libsysdecode, ... }:
mkDerivation {
  path = "usr.bin/truss";
  buildInputs = [libsysdecode];

  clangFixup = true;
}
