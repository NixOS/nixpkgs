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
  version = "11.7.3";
  disabled = ! python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    sha256 = "0gs2w9kl5wwrs0hx2sivq3pdvpf3lkaifblwfbz5g31yl770blji";
  };

  nativeBuildInputs = with python3Packages; [
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
    changelog  = "https://github.com/jbarlow83/OCRmyPDF/blob/v${version}/docs/release_notes.rst";
  };
}
