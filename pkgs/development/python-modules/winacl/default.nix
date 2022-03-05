{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "187b4394ef247806f50e1d8320bdb9e33ad1f759d9e61e2e391b97b9adf5f58a";
  };

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
