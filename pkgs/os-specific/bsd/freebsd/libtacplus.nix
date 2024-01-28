{ mkDerivation, lib, stdenv, libpam, ... }:
mkDerivation {
  path = "lib/libtacplus";
  buildInputs = [libpam];

  clangFixup = true;

  MK_TESTS = "no";
}
