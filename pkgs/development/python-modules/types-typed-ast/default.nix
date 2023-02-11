{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-typed-ast";
  version = "1.5.8.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OmK8JRaPi0TOdOERT5+8Luh9bpbjiAy+85qtlSJVW04=";
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
