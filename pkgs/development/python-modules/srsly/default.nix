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
  version = "2.4.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sPKuwKMp5ufnQqCmDpmnSWjKKb5x81xcTeIh4ygXaSY=";
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
