{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-futures,
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "5.28.0.20240924";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0YGviiVuWpHOjVrbU0luiA79kUTH1USD42UzMrYClvA=";
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
