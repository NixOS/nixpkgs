{
  mkDerivation,
  libbsdxml,
  libsbuf,
}:
mkDerivation {
  path = "lib/libgeom";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  buildInputs = [
    libbsdxml
    libsbuf
  ];

  makeFlags = [
    "SHLIB_MAJOR=1"
    "STRIP=-s"
  ];
}
