{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.25.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    tag = "v${version}";
    hash = "sha256-qPKo/LaOd61XHxFxNkALfOAMV6cKwev+MmjPTTPXKHQ=";
    fetchSubmodules = true;
  };

  # see https://github.com/tree-sitter/py-tree-sitter/issues/330#issuecomment-2629403946
  patches = lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    ./segfault-patch.diff
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

  disabledTests = [
    # test fails in nix sandbox
    "test_dot_graphs"
  ];

  meta =
    let
      # for an -unstable version, we grab the release notes for the last tagged
      # version it is based upon
      lastTag = lib.pipe version [
        lib.splitVersion
        (lib.take 3)
        (lib.concatStringsSep ".")
      ];
    in
    {
      description = "Python bindings to the Tree-sitter parsing library";
      homepage = "https://github.com/tree-sitter/py-tree-sitter";
      changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/v${lastTag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ fab ];
    };
}
