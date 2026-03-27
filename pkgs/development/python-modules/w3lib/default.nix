{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "w3lib";
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4jOtIWSbadDgR6EPMBga6Wd1JKKfb3H288dY3AyNJkg=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "w3lib" ];

  meta = {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
