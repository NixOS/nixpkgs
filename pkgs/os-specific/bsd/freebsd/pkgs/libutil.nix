{ mkDerivation }:
mkDerivation {
  path = "lib/libutil";
  extraPaths = [ "lib/libc/gen" ];
  MK_TESTS = "no";
}
