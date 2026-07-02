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

buildPythonPackage (finalAttrs: {
  pname = "tree-sitter";
  version = "0.26.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-f1D7MdAWqVaYY0M0d+mR+AGNJjXOc41NGqbYG6ruLR4=";
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

  # https://github.com/NixOS/nixpkgs/issues/255262#issuecomment-1721265871
  preCheck = ''
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
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
