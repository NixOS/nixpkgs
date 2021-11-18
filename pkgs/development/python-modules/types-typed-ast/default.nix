{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-typed-ast";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2Op5y/vFIL6Nm8jeSHL0SzQtvbwJFmfi8hsDu9eWkVA=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "typed_ast-stubs" ];

  meta = with lib; {
    description = "Typing stubs for typed-ast";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 veehaitch ];
  };
}
