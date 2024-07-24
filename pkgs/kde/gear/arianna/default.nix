{
  mkKdeDerivation,
  qthttpserver,
  qtsvg,
  qtwebchannel,
  qtwebengine,
  kitemmodels,
}:
mkKdeDerivation {
  pname = "arianna";

  extraBuildInputs = [
    qthttpserver
    qtsvg
    qtwebchannel
    qtwebengine
    kitemmodels
  ];
  meta.mainProgram = "arianna";
}
