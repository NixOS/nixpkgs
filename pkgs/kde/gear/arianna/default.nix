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

  extraNativeBuildInputs = [
    qthttpserver
    qtwebchannel
    qtwebengine
  ];

  extraBuildInputs = [
    qthttpserver
    qtsvg
    qtwebchannel
    qtwebengine
    kitemmodels
  ];

  meta.mainProgram = "arianna";
}
