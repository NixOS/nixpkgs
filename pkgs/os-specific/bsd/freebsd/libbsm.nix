{ mkDerivation, lib, stdenv, libpam, ... }:
mkDerivation {
  path = "lib/libbsm";
  extraPaths = ["contrib/openbsm"];
  buildInputs = [libpam];

  clangFixup = true;

  MK_TESTS = "no";
}
