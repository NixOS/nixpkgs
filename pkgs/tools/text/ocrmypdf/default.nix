{ fetchFromGitHub
, ghostscript
, img2pdf
, jbig2enc
, leptonica
, pngquant
, python3
, python3Packages
, qpdf
, lib
, stdenv
, tesseract4
, unpaper
, substituteAll
}:
let
  inherit (python3Packages) buildPythonApplication;

  runtimeDeps = with python3Packages; [
    ghostscript
    jbig2enc
    leptonica
    pngquant
    qpdf
    tesseract4
    unpaper
    pillow
  ];

in
buildPythonApplication rec {
  pname = "ocrmypdf";
  version = "12.5.0";

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    sha256 = "sha256-g80WedX+TGHE9EJ/RSgOc53PM17V3WZslUNaHoqKTo0=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm-git-archive
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    cffi
    coloredlogs
    img2pdf
    importlib-resources
    pdfminer
    pluggy
    pikepdf
    pillow
    reportlab
    setuptools
    tqdm
  ];

  checkInputs = with python3Packages; [
    pypdf2
    pytest
    pytest-helpers-namespace
    pytest-xdist
    pytest-cov
    python-xmp-toolkit
    pytestCheckHook
  ] ++ runtimeDeps;

  patches = [
    (substituteAll {
      src = ./liblept.patch;
      liblept = "${lib.getLib leptonica}/lib/liblept${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ghostscript jbig2enc pngquant qpdf tesseract4 unpaper ]}" ];

  meta = with lib; {
    homepage = "https://github.com/jbarlow83/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = with licenses; [ mpl20 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.kiwi ];
    changelog = "https://github.com/jbarlow83/OCRmyPDF/blob/v${version}/docs/release_notes.rst";
  };
}
