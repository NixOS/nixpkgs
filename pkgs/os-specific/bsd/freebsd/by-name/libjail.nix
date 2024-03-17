{ mkDerivation, lib, stdenv, ...}:
mkDerivation {
  path = "lib/libjail";
  MK_TESTS = "no";
  clangFixup = true;
}
