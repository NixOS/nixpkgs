{ mkDerivation, stdenv, lib, libkvm, ...}:
mkDerivation {
  path = "lib/libmemstat";
  extraPaths = [];
  buildInputs = [libkvm];
  MK_TESTS = "no";

  clangFixup = true;
}
