{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kstatusnotifieritem";

  hasPythonBindings = true;

  extraNativeBuildInputs = [ qttools ];
}
