{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "usr.bin/cap_mkdb";

  clangFixup = true;

  MK_TESTS = "no";
}
