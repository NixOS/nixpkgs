{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "korganizer";

  extraBuildInputs = [ qttools ];
  meta.mainProgram = "korganizer";
}
