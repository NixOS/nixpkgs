{
  lib,
  mkDerivation,
  libxo,
  libsbuf,
}:
mkDerivation {
  path = "usr.bin/procstat";
  buildInputs = [
    libxo
    libsbuf
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  MK_TESTS = "no";

  meta.platforms = lib.platforms.freebsd;
  meta.mainProgram = "procstat";
}
