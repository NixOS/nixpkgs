{
  mkKdeDerivation,
  qtwayland,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "spectacle";

  extraBuildInputs = [
    qtwayland
    qtmultimedia
  ];
  meta.mainProgram = "spectacle";
}
