{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-futures,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-protobuf";
  version = "7.35.1.20261122";
  pyproject = true;

  src = fetchPypi {
    pname = "types_protobuf";
    inherit (finalAttrs) version;
    hash = "sha256-cFZE8MhhglLqz4eAR9xkm4deuPS3UY3zNlExczNKGXY=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-futures ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "google-stubs" ];

  meta = {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
  };
})
