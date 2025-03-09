{
  mkKdeDerivation,
  qtlocation,
  qtwebview,
  kunifiedpush,
}:
mkKdeDerivation {
  pname = "neochat";

  extraBuildInputs = [
    qtlocation
    qtwebview
    kunifiedpush
  ];
  meta.mainProgram = "neochat";
}
