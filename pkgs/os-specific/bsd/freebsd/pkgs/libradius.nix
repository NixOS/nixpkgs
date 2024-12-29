{
  mkDerivation,
  openssl,
  libmd,
}:
mkDerivation {
  path = "lib/libradius";
  buildInputs = [
    libmd
    openssl
  ];

  MK_TESTS = "no";
}
