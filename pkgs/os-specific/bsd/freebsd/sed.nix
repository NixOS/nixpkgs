{ mkDerivation, ... }:
mkDerivation {
  path = "usr.bin/sed";
  clangFixup = true;
  MK_TESTS = "no";
}
