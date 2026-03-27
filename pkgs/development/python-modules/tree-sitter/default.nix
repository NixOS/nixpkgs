{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  tree-sitter-python,
  tree-sitter-rust,
  tree-sitter-html,
  tree-sitter-javascript,
  tree-sitter-json,
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    tag = "v${version}";
    hash = "sha256-MgiVxq9MUaOkNNgn46g2Cy7/IUx/yatKSR1vE6LscKg=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter-python
    tree-sitter-rust
    tree-sitter-html
    tree-sitter-javascript
    tree-sitter-json
  ];

  pythonImportsCheck = [ "tree_sitter" ];

  preCheck = ''
    # https://github.com/NixOS/nixpkgs/issues/255262#issuecomment-1721265871
    rm -r tree_sitter
  '';

  disabledTests = [
    # Test fails only in the Nix sandbox, with:
    #
    #    AssertionError: Lists differ: ['', '', ''] != ['graph {\n', 'label="new_parse"\n', '}\n']
    "test_dot_graphs"
  ];

  meta = {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
