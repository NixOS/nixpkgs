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
  version = "0.0.28";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "spacy_pkuseg";
    hash = "sha256-mmA/baY9ohvrM41ak5L+G8CUrSQeZCrzmMAoND4X/NI=";
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
