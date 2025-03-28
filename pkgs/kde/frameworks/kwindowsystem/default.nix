{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  qtwayland,
  pkg-config,
  autoPatchPcHook,
}:
mkKdeDerivation {
  pname = "kwindowsystem";

  extraNativeBuildInputs = [
    qttools
    pkg-config
    autoPatchPcHook
  ];
  extraBuildInputs = [
    qtdeclarative
    qtwayland
  ];
}
