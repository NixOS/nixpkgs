{ mkDerivation }:

mkDerivation {
  path = "lib/libnv";
  extraPaths = [
    "sys/contrib/libnv"
    "sys/sys"
  ];
  MK_TESTS = "no";
}
