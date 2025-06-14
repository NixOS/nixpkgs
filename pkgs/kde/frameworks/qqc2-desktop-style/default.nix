{
  mkKdeDerivation,
  qtdeclarative,
  kirigami,
}:
mkKdeDerivation {
  pname = "qqc2-desktop-style";

  extraBuildInputs = [
    qtdeclarative
    kirigami.unwrapped
  ];

  excludeDependencies = [ "kirigami" ];
}
