{ lib
, buildPythonPackage
, fetchPypi
, minikerberos
}:

buildPythonPackage rec {
  pname = "winsspi";
  version = "0.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L1qNLEufRZFEQmkJ4mp05VBRLiO2z5r1LCoAADx8P9s=";
  };
  propagatedBuildInputs = [ minikerberos ];

  # Project doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "winsspi" ];

  meta = with lib; {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winsspi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
