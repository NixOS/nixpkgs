{
  mkKdeDerivation,
  qt5compat,
  qtdeclarative,
  qgpgme,
  kirigami,
  kirigami-addons,
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
    kirigami-addons
    qtwebengine
  ];
}
