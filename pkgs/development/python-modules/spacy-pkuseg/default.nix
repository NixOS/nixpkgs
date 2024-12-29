{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  cython,
  numpy,
  srsly,
}:

buildPythonPackage rec {
  pname = "spacy-pkuseg";
  version = "1.0.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "spacy_pkuseg";
    hash = "sha256-M1MeqOE/wJ6+O0C9l+hNB8zVof5n+o6EFzdpolrAMVg=";
  };

  # Does not seem to have actual tests, but unittest discover
  # recognizes some non-tests as tests and fails.
  doCheck = false;

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
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
