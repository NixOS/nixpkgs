{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-retry";
  version = "0.9.9.20261122";
  pyproject = true;

  src = fetchPypi {
    pname = "types_retry";
    inherit (finalAttrs) version;
    hash = "sha256-+0bOq4Zpkd6ONjVuCkA/43rdymu1ev0OdmyKkRflTmM=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "retry-stubs" ];

  meta = {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
