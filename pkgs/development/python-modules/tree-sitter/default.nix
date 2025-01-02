{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tree-sitter-python,
  tree-sitter-rust,
  tree-sitter-html,
  tree-sitter-javascript,
  tree-sitter-json,
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.23.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-RWnt1g7WN5CDbgWY5YSTuPFZomoxtRgDaSLkG9y2B6w=";
    fetchSubmodules = true;
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/tree-sitter/py-tree-sitter/commit/a85342e16d28c78a1cf1e14c74f4598cd2a5f3e0.patch";
      hash = "sha256-gm79KciA/KoDqrRfWuSB3GOD1jBx6Skd1olt4zoofaw=";
    })
  ];

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

  meta = with lib; {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
