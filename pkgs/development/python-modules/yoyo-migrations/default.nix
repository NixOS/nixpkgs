{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  setuptools,
  sqlparse,
  tabulate,
}:

buildPythonPackage (finalAttrs: {
  pname = "yoyo-migrations";
  version = "8.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ggYGoD4mLPHNT1niVsKPpEZCUiTVuCo9EnX9eBeFI+Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    importlib-metadata
    setuptools
    sqlparse
    tabulate
  ];

  doCheck = false; # pypi tarball does not contain tests

  pythonImportsCheck = [ "yoyo" ];

  meta = {
    description = "Database schema migration tool";
    homepage = "https://ollycope.com/software/yoyo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
