{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "types-openpyxl";
  version = "3.1.5.20261122";

  pyproject = true;

  src = fetchPypi {
    pname = "types_openpyxl";
    inherit (finalAttrs) version;
    hash = "sha256-ELS1cgIa95P6vYdEZZTmIfyaIi5uZktrH0D9UfY43uM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "openpyxl-stubs" ];

  meta = {
    description = "Typing stubs for openpyxl";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.me-and ];
  };
})
