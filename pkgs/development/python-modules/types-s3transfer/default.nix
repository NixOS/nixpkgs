{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "types-s3transfer";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "types_s3transfer";
    inherit version;
    hash = "sha256-rKDySG0KOlA3zVuPPiCkUiopV5qN0YMoH/CqHE4siqc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "s3transfer-stubs"
  ];

  meta = with lib; {
    description = "Type annotations and code completion for s3transfer";
    homepage = "https://github.com/youtype/types-s3transfer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
