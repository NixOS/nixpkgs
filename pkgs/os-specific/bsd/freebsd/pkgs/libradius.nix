{
  mkDerivation,
  openssl,
}:
mkDerivation {
  path = "lib/libradius";
  buildInputs = [
    openssl
  ];

  MK_TESTS = "no";
}
