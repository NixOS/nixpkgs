{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dW/y2Uxk5ByNfAxZ/qEqXQvFXjOlMceYi0oWPeubB90=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "w3lib" ];

  meta = with lib; {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/v${version}/NEWS";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
