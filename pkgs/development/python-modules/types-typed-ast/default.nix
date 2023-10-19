{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-typed-ast";
  version = "1.5.8.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lUO1hj25e0EqKx1fQHyQgzY2WgutME1k6DKKdp9IwjA=";
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
    maintainers = with maintainers; [ veehaitch ];
  };
}
