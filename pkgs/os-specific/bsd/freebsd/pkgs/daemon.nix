{ mkDerivation }:
mkDerivation {
  path = "usr.sbin/daemon";
  MK_TESTS = "no";
}
