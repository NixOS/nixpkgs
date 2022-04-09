{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P037eVRJwheO1cIU7FEUwESx7t1xrQoQA7xnDwnYcQo=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "tabulate-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
