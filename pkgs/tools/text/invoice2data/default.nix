{ lib
, fetchFromGitHub
, imagemagick
, python3
, tesseract
, xpdf
}:

python3.pkgs.buildPythonApplication rec {
  pname = "invoice2data";
  version = "0.3.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "invoice-x";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t1jgLyKtQsLINlnkCdSbVfTM6B/EiD1yGtx9UHjyZVE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-git
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    dateparser
    pdfminer-six
    pillow
    pyyaml
    unidecode
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  makeWrapperArgs = ["--prefix" "PATH" ":" (lib.makeBinPath [
    imagemagick
    tesseract
    xpdf
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
