{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "dolphin";

  outputs = [
    "out"
    "doc"
  ];

  extraBuildInputs = [ qtmultimedia ];

  meta.mainProgram = "dolphin";
}
