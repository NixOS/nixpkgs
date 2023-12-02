{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "types-s3transfer";
  version = "0.8.2";
  pyproject = true;

  src = fetchPypi {
    pname = "types_s3transfer";
    inherit version;
    hash = "sha256-LkF1b8+Ud1qZSa+oVkiaxFcDCGCbBJPfvXtNMz60I+Y=";
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
