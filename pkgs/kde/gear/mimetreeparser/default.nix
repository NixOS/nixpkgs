{
  mkKdeDerivation,
  qt5compat,
  qtdeclarative,
  qgpgme,
  kirigami,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "mimetreeparser";

  extraBuildInputs = [
    qt5compat
    qtdeclarative
    qgpgme
  ];

  extraPropagatedBuildInputs = [
    kirigami
    qtwebengine
  ];
}
