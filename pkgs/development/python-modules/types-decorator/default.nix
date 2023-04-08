{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.1.8.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mt04D8iNDnofJ6hLoc5uKboK1CyqobiOe10n5h9uSWI=";
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
