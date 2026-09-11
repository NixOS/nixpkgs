{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pytz";
  version = "2026.6.0.20261031";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pytz";
    inherit (finalAttrs) version;
    hash = "sha256-i1WZVfDGKPaBWYZcbySDX0MjxAekQINls2dqB0tSQmE=";
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
