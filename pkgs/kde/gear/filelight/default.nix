{
  mkKdeDerivation,
  kirigami,
  kquickcharts,
}:
mkKdeDerivation {
  pname = "filelight";

  extraBuildInputs = [
    kirigami
    kquickcharts
  ];
  meta.mainProgram = "filelight";
}
