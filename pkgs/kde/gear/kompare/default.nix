{mkKdeDerivation}:
mkKdeDerivation {
  pname = "kompare";
  meta = {
    mainProgram = "kompare";
    broken = true; # Qt5
  };
}
