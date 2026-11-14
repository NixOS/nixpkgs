{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  qtmultimedia,
  opencv,
  tesseractLanguages ? [ ],
  tesseract5,
}:
mkKdeDerivation {
  pname = "spectacle";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    (tesseract5.override { enableLanguages = tesseractLanguages; })
    qtwayland
    qtmultimedia
    (opencv.override {
      enableCuda = false; # fails to compile, disabled in case someone sets config.cudaSupport
      enabledModules = [
        "core"
        "imgproc"
      ]; # https://invent.kde.org/graphics/spectacle/-/blob/master/CMakeLists.txt?ref_type=heads#L83
      runAccuracyTests = false; # tests will fail because of missing plugins but that's okay
    })
  ];

  meta.mainProgram = "spectacle";
}
