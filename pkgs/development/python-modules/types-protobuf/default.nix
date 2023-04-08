{ lib
, buildPythonPackage
, fetchPypi
, types-futures
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "4.22.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vytBTYFdw4fAoEHZIH2wVMfNuUWRuyM9m3GoUkPgXvw=";
  };

  propagatedBuildInputs = [
    types-futures
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "google-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
