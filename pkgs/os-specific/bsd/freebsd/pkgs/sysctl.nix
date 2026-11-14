{
  mkDerivation,
  libjail,
}:
mkDerivation {
  path = "sbin/sysctl";
  buildInputs = [
    libjail
  ];
  MK_TESTS = "no";
}
