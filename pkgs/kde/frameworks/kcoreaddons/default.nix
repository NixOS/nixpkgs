{
  mkKdeDerivation,
  qttools,
  shared-mime-info,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcoreaddons";

  extraNativeBuildInputs = [
    qttools
    shared-mime-info
  ];
  extraBuildInputs = [ qtdeclarative ];
}
