{ mkDerivation, lib, stdenv }:
mkDerivation {
  path = "lib/libutil";
  extraPaths = ["lib/libc/gen"];
  clangFixup = true;
  MK_TESTS = "no";
}
