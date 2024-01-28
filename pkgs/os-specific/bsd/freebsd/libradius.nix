{ mkDerivation, lib, stdenv, openssl, libmd, ... }:
mkDerivation {
  path = "lib/libradius";
  buildInputs = [libmd openssl];

  clangFixup = true;

  MK_TESTS = "no";
}
