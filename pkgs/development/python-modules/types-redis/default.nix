{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, types-pyopenssl
}:

buildPythonPackage rec {
  pname = "types-redis";
  version = "4.6.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0O/NlvZf0gNkN8KdjBJWbP3FSTRdc+3aywSIuBr/n54=";
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
