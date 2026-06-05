{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "korganizer";

  outputs = [
    "out"
    "doc"
  ];

  extraBuildInputs = [ qttools ];
  meta.mainProgram = "korganizer";
}
