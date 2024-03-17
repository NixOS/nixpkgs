{ mkDerivation, lib, stdenv, libkvm, ...}:
mkDerivation {
  path = "lib/libdevstat";
  extraPaths = [];
  buildInputs = [libkvm];
  clangFixup = true;
  MK_TESTS = "no";
}
