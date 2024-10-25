{
  mkDerivation,
  libbsdxml,
  libsbuf,
}:
mkDerivation {
  path = "lib/libgeom";
  buildInputs = [
    libbsdxml
    libsbuf
  ];

  makeFlags = [
    "SHLIB_MAJOR=1"
    "STRIP=-s"
  ];
}
