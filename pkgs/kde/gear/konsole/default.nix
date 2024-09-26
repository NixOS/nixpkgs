{
  mkKdeDerivation,
  qt5compat,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "konsole";

  extraBuildInputs = [
    qt5compat
    qtmultimedia
  ];

  meta.mainProgram = "konsole";
}
