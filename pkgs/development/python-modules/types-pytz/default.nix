{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pytz";
  version = "2026.3.1.20260727";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pytz";
    inherit (finalAttrs) version;
    hash = "sha256-Q2QHW2hn3RWyELuMHSlyfWCZFxKbRWAN7+HUs+2l7Lk=";
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
