{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-futures,
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "5.29.1.20250315";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_protobuf";
    inherit version;
    hash = "sha256-CwW8NGIdBG3lS5T93V9Os7+En+LhOlD4+46J81BF/0k=";
  };

  propagatedBuildInputs = [ types-futures ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "google-stubs" ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
