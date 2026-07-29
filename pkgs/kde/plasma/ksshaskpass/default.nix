{
  mkKdeDerivation,
  qtkeychain,
}:
mkKdeDerivation {
  pname = "ksshaskpass";

  extraBuildInputs = [ qtkeychain ];

  meta.mainProgram = "ksshaskpass";
}
