{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage (finalAttrs: {
  pname = "tree-sitter-typescript";
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-typescript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CU55+YoFJb6zWbJnbd38B7iEGkhukSVpBN7sli6GkGY=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "tree_sitter_typescript" ];

  meta = {
    description = "TypeScript grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-typescript";
    changelog = "https://github.com/tree-sitter/tree-sitter-typescript/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
