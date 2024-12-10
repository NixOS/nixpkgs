{
  mkKdeDerivation,
  tesseractLanguages ? [ ],
  tesseract5,
  leptonica,
}:
mkKdeDerivation {
  pname = "skanpage";

  extraBuildInputs = [
    (tesseract5.override { enableLanguages = tesseractLanguages; })
    leptonica
  ];
  meta.mainProgram = "skanpage";
}
