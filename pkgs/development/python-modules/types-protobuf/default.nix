{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-futures,
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "5.29.1.20241207";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_protobuf";
    inherit version;
    hash = "sha256-LrytuKs+8uPi8GfgiCkG1kug3GX8Ww/XqLaSMVtKC+k=";
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
