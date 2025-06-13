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
    qtsvg
    kitemmodels
  ];
  meta.mainProgram = "arianna";
}
