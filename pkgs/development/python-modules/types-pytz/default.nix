{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pytz";
  version = "2026.4.0.20260926";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pytz";
    inherit (finalAttrs) version;
    hash = "sha256-KtXN4RPNaljdWcNPPJPxvOLRJsdpv6wVIHyn1+/WU5A=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pytz-stubs" ];

  meta = {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
