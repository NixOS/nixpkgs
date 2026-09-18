{
  mkKdeDerivation,
  qtmultimedia,
  libssh,
}:
mkKdeDerivation {
  pname = "konsole";

  extraBuildInputs = [
    qtmultimedia

    libssh
  ];

  meta.mainProgram = "konsole";
}
