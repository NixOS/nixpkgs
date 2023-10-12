{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.1.8.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qMOQJGNOmYNL7xRs7C42xYX0eISt303GXW0Lex9idRc=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "decorator-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for decorator";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
