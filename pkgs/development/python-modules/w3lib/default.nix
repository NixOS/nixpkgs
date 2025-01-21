{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/scrapy/w3lib/commit/44dcf9160c3f207658d6ce808307c80c9ca835a2.patch";
      hash = "sha256-fUQ2oWpAJeslgemt+EUxKLH3Ywpg441FCOBLFJCZ+Ac=";
    })
  ];

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
