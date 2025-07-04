{
  mkKdeDerivation,
  qtdeclarative,
  kirigami,
}:
mkKdeDerivation {
  pname = "polkit-kde-agent-1";

  extraBuildInputs = [
    qtdeclarative
    kirigami
  ];
}
