{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  kconfigwidgets,
  kparts,
  kxmlgui,
  ffmpeg,
}:
mkKdeDerivation {
  pname = "dragon";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtmultimedia
    kconfigwidgets
    kparts
    kxmlgui
    ffmpeg
  ];

  meta.mainProgram = "dragon";
}
