{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "63.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KVekCt38pccSX9jThqnv2lN5CYxuZqCOAiV/0c6kITE=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
