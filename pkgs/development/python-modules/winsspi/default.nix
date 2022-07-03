{ lib
, buildPythonPackage
, fetchPypi
, minikerberos
, pythonOlder
}:

buildPythonPackage rec {
  pname = "winsspi";
  version = "0.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L1qNLEufRZFEQmkJ4mp05VBRLiO2z5r1LCoAADx8P9s=";
  };

  propagatedBuildInputs = [
    minikerberos
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "winsspi"
  ];

  meta = with lib; {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winsspi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
