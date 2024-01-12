{ lib
, buildPythonPackage
, fetchPypi
, types-futures
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "4.24.0.20240106";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ak8DTzteK7K7/1XrxNWR7Q0igNkPrO7csUi55xSj8+4=";
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
