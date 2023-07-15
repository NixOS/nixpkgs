{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "0.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EIUbKL8DNFNNGmLRcu12mlw4H+gAHmCUw09eLG0s8+M=";
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
