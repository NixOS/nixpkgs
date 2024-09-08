{
  mkKdeDerivation,
  qtdeclarative,
  pkg-config,
  networkmanager,
}:
mkKdeDerivation {
  pname = "networkmanager-qt";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtdeclarative];
  extraPropagatedBuildInputs = [networkmanager];
}
