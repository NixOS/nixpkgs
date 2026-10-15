{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kxmlgui";

  hasPythonBindings = true;

  extraBuildInputs = [ qttools ];
}
