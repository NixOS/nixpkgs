{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5GgDu9HRj6fIX66q3RuDeB13h6dpwxrSBxKhzE+Fus=";
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
