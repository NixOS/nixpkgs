{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  qtwayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "kwindowsystem";

  extraNativeBuildInputs = [qttools pkg-config];
  extraBuildInputs = [qtdeclarative qtwayland];
}
