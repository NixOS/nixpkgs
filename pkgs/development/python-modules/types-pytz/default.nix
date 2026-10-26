{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pytz";
  version = "2026.5.0.20261006";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pytz";
    inherit (finalAttrs) version;
    hash = "sha256-GlIsLsA6rY1LqvlxBZWAGa1RcEseRxyILRxszqPl5ks=";
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
