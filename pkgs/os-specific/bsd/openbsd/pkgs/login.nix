{
  mkDerivation,
  libutil,
}:
mkDerivation {
  path = "usr.bin/login";
  buildInputs = [
    libutil
  ];

  meta.mainProgram = "login";
}
