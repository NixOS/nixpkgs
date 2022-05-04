{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-typed-ast";
  version = "1.5.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MlOHn/Y6+4lkZa/kIoocTfLmPNw57vm5dD1QC42aUXY=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "typed_ast-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for typed-ast";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 veehaitch ];
  };
}
