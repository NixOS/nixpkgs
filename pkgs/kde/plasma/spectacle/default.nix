{
  lib,
  mkKdeDerivation,
  qtwayland,
  qtmultimedia,
  opencv,
  tesseractLanguages ? [ ],
  tesseract5,
}:
let
  tesseract = tesseract5.override { enableLanguages = tesseractLanguages; };
in
mkKdeDerivation {
  pname = "spectacle";

  extraBuildInputs = [
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

  # no point adding the dependency when we have no language packs
  preFixup = lib.optionalString (tesseractLanguages != [ ]) ''
    patchelf --add-needed libtesseract.so.5 --add-rpath ${tesseract}/lib $out/bin/spectacle
  '';

  meta.mainProgram = "spectacle";
}
