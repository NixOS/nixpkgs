{ mkDerivation, freebsdSrc }:

mkDerivation {
  path = "usr.bin/sed";
  TESTSRC = "${freebsdSrc}/contrib/netbsd-tests";
  MK_TESTS = "no";
}
