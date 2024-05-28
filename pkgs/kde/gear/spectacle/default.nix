{
  mkKdeDerivation,
  qtwayland,
  qtmultimedia,
  opencv,
}:
mkKdeDerivation {
  pname = "spectacle";

  extraBuildInputs = [qtwayland qtmultimedia opencv];
  meta.mainProgram = "spectacle";
}
