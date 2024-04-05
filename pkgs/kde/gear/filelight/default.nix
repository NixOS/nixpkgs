{
  mkKdeDerivation,
  kirigami,
  kquickcharts,
  qqc2-desktop-style,
}:
mkKdeDerivation {
  pname = "filelight";

  extraBuildInputs = [
    kirigami
    kquickcharts
    qqc2-desktop-style
  ];
  meta.mainProgram = "filelight";
}
