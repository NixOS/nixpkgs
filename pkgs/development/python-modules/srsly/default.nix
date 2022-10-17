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
  version = "2.4.4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6KBlgWJ7ZxLxnGAkG3wUwrspzobvBPeRN5p58bJJoSg=";
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
