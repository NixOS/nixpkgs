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
