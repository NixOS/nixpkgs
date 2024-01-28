{ mkDerivation, lib, stdenv, libelf, ...}:
mkDerivation {
  path = "lib/libexecinfo";
  extraPaths = ["contrib/libexecinfo"];
  buildInputs = [libelf];
  MK_TESTS = "no";
  clangFixup = true;
}
