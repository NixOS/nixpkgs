{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.20.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "tree_sitter";
    inherit version;
    hash = "sha256-atsSPi8+VjmbvyNZkkYzyILMQO6DRIhSALygki9xO+U=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # PyPI tarball doesn't contains tests and source has additional requirements
  doCheck = false;

  pythonImportsCheck = [
    "tree_sitter"
  ];

  meta = with lib; {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
