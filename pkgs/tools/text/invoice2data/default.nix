{ lib
, fetchFromGitHub
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
    sha256 = "sha256-ss2h8cg0sga+lzJyQHckrZB/Eb63Oj3FkqmGqWCzCQ8=";
  };

  buildInputs = with python3.pkgs; [ setuptools-git ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    dateparser
    pdfminer-six
    pillow
    pyyaml
    setuptools
    unidecode
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

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
