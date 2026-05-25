{
  mkDerivation,
  libcapsicum,
  libcasper,
}:
mkDerivation {
  path = "usr.bin/backlight";

  buildInputs = [
    libcapsicum
    libcasper
  ];
}
