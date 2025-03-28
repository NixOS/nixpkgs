{
  mkKdeDerivation,
  pkg-config,
  autoPatchPcHook,
  qtwayland,
}:
mkKdeDerivation {
  pname = "kwayland";

  extraNativeBuildInputs = [
    pkg-config
    autoPatchPcHook
  ];
  extraBuildInputs = [ qtwayland ];
}
