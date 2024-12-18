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

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtsvg qttools qtwebchannel qtwebengine qt5compat kdoctools hunspell];
  meta.mainProgram = "ghostwriter";
}
