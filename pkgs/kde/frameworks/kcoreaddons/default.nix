{
  mkKdeDerivation,
  qttools,
  shared-mime-info,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcoreaddons";

  hasPythonBindings = true;

  extraNativeBuildInputs = [
    qttools
    shared-mime-info
  ];
  extraBuildInputs = [ qtdeclarative ];
}
