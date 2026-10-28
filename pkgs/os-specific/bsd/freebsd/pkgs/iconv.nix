{
  mkDerivation,
  libcapsicum,
  libcasper,
}:
mkDerivation {
  path = "usr.bin/iconv";
  buildInputs = [
    libcapsicum
    libcasper
  ];
}
