{
  mkKdeDerivation,
  shared-mime-info,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcoreaddons";

  extraNativeBuildInputs = [
    shared-mime-info
  ];
  extraBuildInputs = [ qtdeclarative ];
}
