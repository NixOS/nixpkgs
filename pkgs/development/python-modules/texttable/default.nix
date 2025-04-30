{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LSBo+1URWAfTrHekymj6SIA+hOuw7iNA+FgQejZSJjg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "texttable" ];

  enabledTestPaths = [ "tests.py" ];

  meta = with lib; {
    description = "Module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    changelog = "https://github.com/foutaise/texttable/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
