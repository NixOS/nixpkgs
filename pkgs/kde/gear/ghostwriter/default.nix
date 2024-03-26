{
  mkKdeDerivation,
  qtsvg,
  qttools,
  qtwebchannel,
  qtwebengine,
  qt5compat,
  pkg-config,
  hunspell,
  kdoctools,
}:
mkKdeDerivation {
  pname = "ghostwriter";

  extraNativeBuildInputs = [pkg-config kdoctools];
  extraBuildInputs = [qtsvg qttools qtwebchannel qtwebengine qt5compat hunspell];
  meta.mainProgram = "ghostwriter";
}
