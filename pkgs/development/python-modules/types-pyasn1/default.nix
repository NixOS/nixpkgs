{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pyasn1";
  version = "0.6.0.20261113";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pyasn1";
    inherit (finalAttrs) version;
    hash = "sha256-1tSAupV9Jw7W2Pk9h1KUu5lu0HPWmuw3mIKX5LUFfWM=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pyasn1-stubs" ];

  meta = {
    description = "Typing stubs for pyasn1";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dmfrpro ];
  };
})
