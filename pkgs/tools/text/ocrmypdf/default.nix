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

in buildPythonApplication rec {
  pname = "ocrmypdf";
  version = "9.0.3";
  disabled = ! python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    sha256 = "1qnjdcbwkxxqfahylzl0wj1gk51yi9m8akd4d1rrq37vg2vwdkjy";
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
    img2pdf
    pdfminer
    pikepdf
    pillow
    reportlab
    ruffus
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
    setuptools
  ] ++ runtimeDeps;

  postPatch = ''
    substituteInPlace src/ocrmypdf/leptonica.py \
      --replace "ffi.dlopen(find_library('lept'))" \
      'ffi.dlopen("${stdenv.lib.makeLibraryPath [leptonica]}/liblept${stdenv.hostPlatform.extensions.sharedLibrary}")'
  '';

  # The tests take potentially 20+ minutes, depending on machine
  doCheck = false;

  # These tests fail and it might be upstream problem... or packaging. :)
  # development is happening on macos and the pinned test versions are
  # significantly newer than nixpkgs has. Program still works...
  # (to the extent I've used it) -- Kiwi
  checkPhase = ''
    export HOME=$TMPDIR
    pytest -k 'not test_force_ocr_on_pdf_with_no_images \
    and not test_tesseract_crash \
    and not test_tesseract_crash_autorotate \
    and not test_ghostscript_pdfa_failure \
    and not test_gs_render_failure \
    and not test_gs_raster_failure \
    and not test_bad_utf8 \
    and not test_old_unpaper'
  '';

  makeWrapperArgs = [ "--prefix PATH : ${stdenv.lib.makeBinPath [ ghostscript jbig2enc pngquant qpdf tesseract4 unpaper ]}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jbarlow83/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.kiwi ];
  };
}
