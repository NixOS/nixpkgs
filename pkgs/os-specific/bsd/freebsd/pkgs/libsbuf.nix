{ mkDerivation }:

mkDerivation {
  path = "lib/libsbuf";
  extraPaths = [ "sys/kern" ];
  env.MK_TESTS = "no";
}
