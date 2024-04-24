{ mkDerivation, source }:

mkDerivation {
  path = "usr.bin/sed";
  TESTSRC = "${source}/contrib/netbsd-tests";
  MK_TESTS = "no";
}
