{
  mkDerivation,
  libjail,
  libxo,
  libcasper,
  libcapsicum,
}:
mkDerivation {
  path = "usr.bin/sockstat";
  outputs = [
    "out"
    "debug"
  ];
  buildInputs = [
    libjail
    libxo
    libcasper
    libcapsicum
  ];
  MK_TESTS = "no";

  meta.mainProgram = "sockstat";
}
