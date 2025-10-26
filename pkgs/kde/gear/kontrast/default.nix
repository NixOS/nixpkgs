{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kontrast";

  extraBuildInputs = [
    qtsvg
  ];
  meta.mainProgram = "kontrast";
}
