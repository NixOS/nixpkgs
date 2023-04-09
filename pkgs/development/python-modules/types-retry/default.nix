{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-retry";
  version = "0.9.9.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G3oKBK3xLyEjfnaDNXSpqPdV+IiJwiatmdbjv6W248g=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "retry-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
