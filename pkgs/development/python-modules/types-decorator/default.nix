{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WBcQj9v71OppsQcrG1fJpyakF4z9CBYMtb1PmTdptsE=";
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
