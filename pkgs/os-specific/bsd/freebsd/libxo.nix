{ mkDerivation, ...}:
mkDerivation {
  path = "lib/libxo";
  extraPaths = ["contrib/libxo"];
  MK_TESTS = "no";
  clangFixup = true;
}
