{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.8.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F6X6O1ykU4FXePyYZejs0BGLB7K5+v8+Kwb+RIF03V4=";
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
