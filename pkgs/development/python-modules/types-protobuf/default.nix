{ lib
, buildPythonPackage
, fetchPypi
, types-futures
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "3.20.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Da06UAmJXJhaVuKDf2GQK62VlBUSZawO6Qe7FtCwHrc=";
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
