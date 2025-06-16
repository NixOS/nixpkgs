{
  mkKdeDerivation,
  shared-mime-info,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcoreaddons";

  hasPythonBindings = true;

  extraNativeBuildInputs = [
    shared-mime-info
  ];
  extraBuildInputs = [ qtdeclarative ];
}
