{ lib
, buildPythonPackage
, fetchPypi
, pycryptodome
, pycryptodomex
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unicrypto";
  version = "0.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BIf53ZAJwybulTGnlBKuGK1nNCWhyADWSUe5b96wTN8=";
  };

  propagatedBuildInputs = [
    pycryptodome
    pycryptodomex
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "unicrypto"
  ];

  meta = with lib; {
    description = "Unified interface for cryptographic libraries";
    homepage = "https://github.com/skelsec/unicrypto";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
