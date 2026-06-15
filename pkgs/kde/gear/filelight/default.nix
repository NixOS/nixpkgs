{
  mkKdeDerivation,
  kirigami-addons,
  kquickcharts,
  kxmlgui,
}:
mkKdeDerivation {
  pname = "filelight";

  outputs = [
    "out"
    "doc"
  ];

  extraBuildInputs = [
    kirigami-addons
    kquickcharts
    kxmlgui
  ];
  meta.mainProgram = "filelight";
}
