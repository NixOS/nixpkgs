{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  matplotlib,
  pytest,
  setuptools,
  scipy,
}:

buildPythonPackage rec {
  pname = "tadasets";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C+l19J0PHjZTlzAhXbojicaOyr/gjN8fuH7cLyb449w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [
    pytest
    scipy
  ];

  meta = {
    description = "Great data sets for Topological Data Analysis";
    homepage = "https://tadasets.scikit-tda.org";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
