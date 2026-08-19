{
  mkKdeDerivation,
  kirigami-addons,
  kquickcharts,
  kxmlgui,
}:
mkKdeDerivation {
  pname = "filelight";

  extraBuildInputs = [
    kirigami-addons
    kquickcharts
    kxmlgui
  ];
  meta.mainProgram = "filelight";
}
