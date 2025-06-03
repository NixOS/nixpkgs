{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcmutils";

  extraPropagatedBuildInputs = [ qtdeclarative ];
  meta.mainProgram = "kcmshell6";
}
