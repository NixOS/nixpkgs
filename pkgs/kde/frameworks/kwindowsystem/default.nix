{
  mkKdeDerivation,
  qtdeclarative,
  qtwayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "kwindowsystem";

  extraNativeBuildInputs = [
    pkg-config
  ];
  extraBuildInputs = [
    qtdeclarative
    qtwayland
  ];
}
