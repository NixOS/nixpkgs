{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, catalogue
, mock
, numpy
, pytest
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "srsly";
  version = "2.4.5";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yEIliWe6pSfOqTZ5huQrgUOhqJDn1KGNJaNu3Dx6M8c=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ catalogue ];

  checkInputs = [
    mock
    numpy
    pytest
    ruamel-yaml
  ];

  pythonImportsCheck = [ "srsly" ];

  meta = with lib; {
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = licenses.mit;
  };
}
