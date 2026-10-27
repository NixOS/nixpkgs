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
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "spacy_pkuseg";
    hash = "sha256-IK6pquzp/LqOjylbVbRjv4DNkwA5qLYApRNG+nOlhpc=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    srsly
  ];

  # Does not seem to have actual tests, but unittest discover
  # recognizes some non-tests as tests and fails.
  doCheck = false;

  pythonImportsCheck = [ "spacy_pkuseg" ];

  meta = {
    description = "Chinese word segmentation toolkit for spaCy (fork of pkuseg-python)";
    homepage = "https://github.com/explosion/spacy-pkuseg";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
