{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pythonAtLeast,
  setuptools,
  distutils,
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.21.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-HT1sRzDFpeelWCq1ZMeRmoUg0a3SBR7bZKxBqn4fb2g=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tree_sitter" ];

  # Needed explicitly for Python >= 3.12 as tree-sitter provides
  # calls to distutils functions to compile language files
  dependencies = lib.optionals (pythonAtLeast "3.12") [ distutils ];

  preCheck = ''
    rm -r tree_sitter
  '';

  meta = with lib; {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
