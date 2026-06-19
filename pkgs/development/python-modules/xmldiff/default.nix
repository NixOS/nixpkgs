{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xmldiff";
  version = "3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OA7E0FzvM/W3Bs94mrzISNJ3MNZ+AtwLTxEH4Wzpqq0=";
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
