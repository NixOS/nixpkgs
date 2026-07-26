{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "dolphin";

  extraBuildInputs = [ qtmultimedia ];

  meta.mainProgram = "dolphin";
}
