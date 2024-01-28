{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "usr.bin/stat";

  clangFixup = true;

  MK_TESTS = "no";
}
