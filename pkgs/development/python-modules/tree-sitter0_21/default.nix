{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tree-sitter0_21";
  version = "0.21.3";
  pyproject = true;

  # https://github.com/tree-sitter/py-tree-sitter/issues/209
  disabled = pythonAtLeast "3.12" || pythonOlder "3.7";

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
