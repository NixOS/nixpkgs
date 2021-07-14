{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-typed-ast";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-akcWV2AyGDXRYNogpqxbkGXyPW3CRhYlCMrR7xI4r8M=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "typed_ast-stubs" ];

  meta = with lib; {
    description = "Typing stubs for typed-ast";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
