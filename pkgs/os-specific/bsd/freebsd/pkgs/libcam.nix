{
  lib,
  libsbuf,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libcam";
  extraPaths = [
    "sys/cam"
  ];
  buildInputs = [
    libsbuf
  ];
  MK_TESTS = "no";
  meta.platforms = lib.platforms.freebsd;
}
