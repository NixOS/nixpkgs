{
  mkDerivation,
}:
mkDerivation {
  path = "sbin/swapon";
  MK_TESTS = "no";
}
