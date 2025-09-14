{
  mkKdeDerivation,
  qtdeclarative,
  kirigami,
  knotifications,
}:
mkKdeDerivation {
  pname = "polkit-kde-agent-1";

  extraBuildInputs = [
    qtdeclarative
    kirigami
    knotifications
  ];
}
