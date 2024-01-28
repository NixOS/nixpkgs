{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "lib/libypclnt";
  extraPaths = ["include/rpcsvc"];

  clangFixup = true;

  MK_TESTS = "no";
}
