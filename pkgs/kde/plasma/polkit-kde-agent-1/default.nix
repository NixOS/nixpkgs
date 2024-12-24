{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "polkit-kde-agent-1";

  extraBuildInputs = [ qtdeclarative ];
}
