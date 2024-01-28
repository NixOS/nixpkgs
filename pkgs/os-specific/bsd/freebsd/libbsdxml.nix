{ mkDerivation, lib, stdenv, ...}:
mkDerivation {
  path = "lib/libexpat";
  extraPaths = ["contrib/expat"];
  buildInputs = [];
  clangFixup = true;
}
