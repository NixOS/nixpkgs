{
  mkKdeDerivation,
  intltool,
  qtdeclarative,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kaccounts-providers";

  extraNativeBuildInputs = [
    intltool
    qtwebengine
  ];

  extraBuildInputs = [
    qtdeclarative
    qtwebengine
  ];
}
