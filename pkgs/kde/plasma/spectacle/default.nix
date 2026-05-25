{
  fetchpatch,
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

  # Backport the upstream switch from runtime QLibrary loading to direct
  # linking so Spectacle OCR can find Tesseract reliably on NixOS.
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/graphics/spectacle/-/commit/13b0be099e7abe9bbb17b90e62c2e83afb248db7.patch";
      hash = "sha256-HEgHsuajaF+WVMiRp0YKRmi+/NsIy5s8frwMJRIdDY8=";
    })
  ];

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
