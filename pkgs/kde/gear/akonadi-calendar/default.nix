{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "akonadi-calendar";

  hasPythonBindings = true;

  meta.mainProgram = "kalendarac";
}
