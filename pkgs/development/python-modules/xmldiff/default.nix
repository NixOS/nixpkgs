{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  lxml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xmldiff";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wJELH4ADZt1+xikj5dBuiwahvZEgVpocJ/TyRGucaKI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # lxml 6.0 compat issue
    "test_api_diff_texts"
  ];

  pythonImportsCheck = [ "xmldiff" ];

  meta = {
    description = "Creates diffs of XML files";
    homepage = "https://github.com/Shoobx/xmldiff";
    changelog = "https://github.com/Shoobx/xmldiff/blob/master/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
}
