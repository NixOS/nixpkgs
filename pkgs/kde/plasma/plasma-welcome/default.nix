{
  mkKdeDerivation,
  qtsvg,
  kuserfeedback,
}:
mkKdeDerivation {
  pname = "plasma-welcome";

  extraBuildInputs = [qtsvg kuserfeedback];
  meta.mainProgram = "plasma-welcome";
}
