{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ymYsCRRxpsYp12xe7GPYob8a98BUNI8JwSQvM4hQsr0=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography>=38.0.1" "cryptography"
  '';

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "winacl"
  ];

  meta = with lib; {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winacl";
    changelog = "https://github.com/skelsec/winacl/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
