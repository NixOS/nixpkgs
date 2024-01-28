{ mkDerivation, libncurses-tinfo, lib, stdenv, ...}:
mkDerivation {
  path = "lib/libedit";
  extraPaths = ["contrib/libedit"];
  buildInputs = [libncurses-tinfo];
  MK_TESTS = "no";

  clangFixup = true;
}
