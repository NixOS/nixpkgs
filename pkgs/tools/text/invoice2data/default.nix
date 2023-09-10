{ lib
, fetchFromGitHub
, fetchpatch
, ghostscript
, imagemagick
, poppler_utils
, python3
, tesseract5
}:

python3.pkgs.buildPythonApplication rec {
  pname = "invoice2data";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "invoice-x";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ss2h8cg0sga+lzJyQHckrZB/Eb63Oj3FkqmGqWCzCQ8=";
  };

  patches = [
    # https://github.com/invoice-x/invoice2data/pull/522
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/invoice-x/invoice2data/commit/ccea3857c7c8295ca51dc24de6cde78774ea7e64.patch";
      hash = "sha256-BhqPW4hWG/EaR3qBv5a68dcvIMrCCT74GdDHr0Mss5Q=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools-git
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dateparser
    pdfminer-six
    pillow
    pyyaml
  ];

  makeWrapperArgs = ["--prefix" "PATH" ":" (lib.makeBinPath [
    ghostscript
    imagemagick
    tesseract5
    poppler_utils
  ])];

  # Tests fails even when ran manually on my ubuntu machine !!
  doCheck = false;

  pythonImportsCheck = [
    "invoice2data"
  ];

  meta = with lib; {
    description = "Data extractor for PDF invoices";
    homepage = "https://github.com/invoice-x/invoice2data";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
