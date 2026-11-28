{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.7.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/5mqdWLGy80JgstvrpFFEmsZh4GCSWzcRrjWgWchxdo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "texttable" ];

  enabledTestPaths = [ "tests.py" ];

  meta = {
    description = "Module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    changelog = "https://github.com/foutaise/texttable/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
