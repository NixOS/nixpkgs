{ mkDerivation }:

mkDerivation {
  path = "lib/libsbuf";
  extraPaths = [
    "sys/kern"
  ];
  MK_TESTS = "no";
}
