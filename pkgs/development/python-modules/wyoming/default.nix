{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mgNhc8PMRrwfvGZEcgIvQ/P2dysdDo2juvZccvb2C/g=";
  };

  pythonImportsCheck = [
    "wyoming"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://pypi.org/project/wyoming/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
