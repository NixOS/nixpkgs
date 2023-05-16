{ lib
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
    sha256 = "sha256-ss2h8cg0sga+lzJyQHckrZB/Eb63Oj3FkqmGqWCzCQ8=";
  };

  buildInputs = with python3.pkgs; [ setuptools-git ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dateparser
    pdfminer-six
    pillow
    pyyaml
<<<<<<< HEAD
  ];

=======
    setuptools
    unidecode
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
