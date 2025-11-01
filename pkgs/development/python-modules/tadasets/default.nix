{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  matplotlib,
  pytest,
  scipy,
}:

buildPythonPackage rec {
  pname = "tadasets";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C+l19J0PHjZTlzAhXbojicaOyr/gjN8fuH7cLyb449w=";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [
    pytest
    scipy
  ];

  meta = with lib; {
    description = "Great data sets for Topological Data Analysis";
    homepage = "https://tadasets.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ ];
  };
}
