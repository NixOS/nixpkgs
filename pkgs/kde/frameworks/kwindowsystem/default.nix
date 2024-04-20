{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  qtwayland,
  pkg-config,
  wayland,
}:
mkKdeDerivation {
  pname = "kwindowsystem";

  extraNativeBuildInputs = [qttools pkg-config];
  extraBuildInputs = [qtdeclarative qtwayland wayland];
}
