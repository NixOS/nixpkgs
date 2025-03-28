{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  autoPatchPcHook,
}:
mkKdeDerivation {
  pname = "kguiaddons";

  extraNativeBuildInputs = [
    pkg-config
    autoPatchPcHook
  ];
  extraBuildInputs = [ qtwayland ];
  meta.mainProgram = "kde-geo-uri-handler";
}
