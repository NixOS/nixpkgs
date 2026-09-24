{
  mkDerivation,
  libcapsicum,
  libcasper,
}:
mkDerivation {
  path = "usr.bin/logger";
  outputs = [
    "out"
    "debug"
  ];
  buildInputs = [
    libcasper
    libcapsicum
  ];
}
