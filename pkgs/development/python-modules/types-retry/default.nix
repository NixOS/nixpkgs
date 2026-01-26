{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-retry";
  version = "0.9.9.20250322";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_retry";
    inherit version;
    hash = "sha256-LqpvS4MsGHEhBWmIu+bS0Lb06wNjH9yXUuKsKAL3tyY=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "retry-stubs" ];

  meta = {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
