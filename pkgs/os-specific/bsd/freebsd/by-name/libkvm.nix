{ mkDerivation, stdenv, lib, libelf, ...}:
mkDerivation {
  path = "lib/libkvm";
  extraPaths = ["sys"];
  buildInputs = [libelf];
  MK_TESTS = "no";

  clangFixup = true;
}
