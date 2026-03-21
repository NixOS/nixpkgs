{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XIrAKjAnV2F0wrYeuaIXC6Gxl8rnZwgHcbbx/r2iSaQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "w3lib" ];

  meta = {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/v${version}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
