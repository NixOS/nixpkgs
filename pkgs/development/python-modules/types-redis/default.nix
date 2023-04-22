{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, types-pyopenssl
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.5.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vwQZL0FbK0Ls79cLtLkesDUuSPJxaiE+A441wJamOcI=";
  };

  propagatedBuildInputs = [
    cryptography
    types-pyopenssl
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "redis-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for redis";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
