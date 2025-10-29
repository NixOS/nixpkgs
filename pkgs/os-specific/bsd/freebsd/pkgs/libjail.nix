{ mkDerivation }:
mkDerivation {
  path = "lib/libjail";
  MK_TESTS = "no";
}
