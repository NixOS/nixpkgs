{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  setuptools,
  numpy,
  srsly,
}:

buildPythonPackage rec {
  pname = "spacy-pkuseg";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "spacy_pkuseg";
    hash = "sha256-tIB4d1r/80kUN1NE1W9wo37ARBiMyuzj9wgG/TIqR+s=";
  };

  # Does not seem to have actual tests, but unittest discover
  # recognizes some non-tests as tests and fails.
  doCheck = false;

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    srsly
  ];

  pythonImportsCheck = [ "spacy_pkuseg" ];

  meta = with lib; {
    description = "Toolkit for multi-domain Chinese word segmentation (spaCy fork)";
    homepage = "https://github.com/explosion/spacy-pkuseg";
    license = licenses.mit;
    maintainers = [ ];
  };
}
