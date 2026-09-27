{
  mkKdeDerivation,
  shared-mime-info,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kpkpass";

  extraNativeBuildInputs = [ shared-mime-info ];
  extraBuildInputs = [ qtdeclarative ];
}
