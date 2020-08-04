{ fetchFromGitHub
, ghostscript
, img2pdf
, jbig2enc
, leptonica
, pngquant
, python3
, python3Packages
, qpdf
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
  version = "10.3.0";
  disabled = ! python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    sha256 = "0c6v7846lmkmbyfla07s35mpba4h09h0fx6pxqf0yvdjxmj46q8c";
  };

  nativeBuildInputs = with python3Packages; [
    pytestrunner
    setuptools
    setuptools-scm-git-archive
    setuptools_scm
  ];

  propagatedBuildInputs = with python3Packages; [
    cffi
    chardet
    coloredlogs
    img2pdf
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
    pytest_xdist
    pytestcov
    pytestrunner
    python-xmp-toolkit
    pytestCheckHook
  ] ++ runtimeDeps;

  patches = [
    (substituteAll {
      src = ./liblept.patch;
      liblept = "${stdenv.lib.getLib leptonica}/lib/liblept${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
    # https://github.com/jbarlow83/OCRmyPDF/pull/596
    ./0001-Make-compatible-with-pdfminer.six-version-20200720.patch
  ];

  makeWrapperArgs = [ "--prefix PATH : ${stdenv.lib.makeBinPath [ ghostscript jbig2enc pngquant qpdf tesseract4 unpaper ]}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jbarlow83/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.kiwi ];
  };
}
