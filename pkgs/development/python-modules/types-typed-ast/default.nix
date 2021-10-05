{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-typed-ast";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffa0471e0ba19c4ea0cba0436d660871b5f5215854ea9ead3cb5b60f525af75a";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "typed_ast-stubs" ];

  meta = with lib; {
    description = "Typing stubs for typed-ast";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj veehaitch ];
  };
}
