{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pythonOlder
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sgpTQovEps19e05sgfznyiP9k2SwKsjcC1ZTfAHeQqQ=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "winacl" ];

  meta = with lib; {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winacl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
