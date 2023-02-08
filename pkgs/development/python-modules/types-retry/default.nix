{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-retry";
  version = "0.9.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NE6tQ4fg6YxtYDdYwTGO5OWwRCnOy5o0Khz4c947UQ0=";
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
