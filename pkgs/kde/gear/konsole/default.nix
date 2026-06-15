{
  mkKdeDerivation,
  qt5compat,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "konsole";

  outputs = [
    "out"
    "doc"
  ];

  extraBuildInputs = [
    qt5compat
    qtmultimedia
  ];

  meta.mainProgram = "konsole";
}
