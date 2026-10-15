{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stdiomask";
  version = "0.0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-weRwaerZ4QvaFQom95IsoB0q3FAwQqnXrPZId6K5o6Y=";
  };

  build-system = [ setuptools ];

  # tests are not published: https://github.com/asweigart/stdiomask/issues/5
  doCheck = false;
  pythonImportsCheck = [ "stdiomask" ];

  meta = {
    description = "Python module for masking passwords";
    homepage = "https://github.com/asweigart/stdiomask";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
