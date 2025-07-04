{ mkDerivation }:
mkDerivation {
  path = "sbin/reboot";

  MK_TESTS = "no";
}
