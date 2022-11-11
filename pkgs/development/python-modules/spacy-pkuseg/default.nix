{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, cython
, numpy
, srsly
}:

buildPythonPackage rec {
  pname = "spacy-pkuseg";
  version = "0.0.32";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "spacy_pkuseg";
    hash = "sha256-9y2TZROOkIOl54u6jocZD4WtP5Ct3bVfacWKqGLISEw=";
  };

  # Does not seem to have actual tests, but unittest discover
  # recognizes some non-tests as tests and fails.
  doCheck = false;

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ numpy srsly ];

  pythonImportsCheck = [ "spacy_pkuseg" ];

  meta = with lib; {
    description = "Toolkit for multi-domain Chinese word segmentation (spaCy fork)";
    homepage = "https://github.com/explosion/spacy-pkuseg";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
