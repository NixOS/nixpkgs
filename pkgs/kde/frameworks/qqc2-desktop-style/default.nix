{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  kirigami,
}:
mkKdeDerivation {
  pname = "qqc2-desktop-style";

  extraNativeBuildInputs = [ qttools ];
  extraBuildInputs = [
    qtdeclarative
    kirigami.unwrapped
  ];

  excludeDependencies = [ "kirigami" ];
}
