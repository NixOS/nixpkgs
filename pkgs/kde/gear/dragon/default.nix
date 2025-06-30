{
  mkKdeDerivation,
  kconfigwidgets,
  kparts,
  kxmlgui,
  phonon,
}:
mkKdeDerivation {
  pname = "dragon";

  extraBuildInputs = [
    kconfigwidgets
    kparts
    kxmlgui
    phonon
  ];

  meta.mainProgram = "dragon";
}
