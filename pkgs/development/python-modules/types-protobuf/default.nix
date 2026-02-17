{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-futures,
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "6.32.1.20251210";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_protobuf";
    inherit version;
    hash = "sha256-xpi7PwICdLGieYrgncdzcozj91IJo1GHvRGRbr/eZ2M=";
  };

  propagatedBuildInputs = [ types-futures ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "google-stubs" ];

  meta = {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
  };
}
