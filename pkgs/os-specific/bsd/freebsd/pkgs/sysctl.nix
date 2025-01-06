{ mkDerivation, ... }:
mkDerivation {
  path = "sbin/sysctl";
  MK_TESTS = "no";
}
