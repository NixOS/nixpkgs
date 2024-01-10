{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-ujson";
  version = "5.9.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fnBCRU3HzX8xsJxCDXyvNrk9ML30uNuTeRvQVhcT0Bc=";
  };

  doCheck = false;

  pythonImportsCheck = [
    "ujson-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}
