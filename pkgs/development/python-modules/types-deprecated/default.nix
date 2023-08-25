{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.2.9.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-Deprecated";
    inherit version;
    hash = "sha256-74cyet8+PEpMfY4G5Y9kdnENNGbs+1PEnvsICASnDvM=";
  };

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [
    "deprecated-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
