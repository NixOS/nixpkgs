{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kwidgetsaddons";

  hasPythonBindings = true;

  extraNativeBuildInputs = [ qttools ];
}
