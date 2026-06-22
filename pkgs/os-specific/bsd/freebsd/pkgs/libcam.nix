{
  lib,
  libsbuf,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libcam";
  extraPaths = [
    "sys/cam"
    "sys/dev/nvme"
  ];
  buildInputs = [
    libsbuf
  ];
  MK_TESTS = "no";
  meta.platforms = lib.platforms.freebsd;
}
