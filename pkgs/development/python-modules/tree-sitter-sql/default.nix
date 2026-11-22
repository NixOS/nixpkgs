{
  lib,
  buildPythonPackage,
  fetchurl,

  # build-system
  setuptools,

  #optional-dependencies
  tree-sitter,

  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "tree-sitter-sql";
  version = "0.3.13";
  pyproject = true;

  # The git tree does not contain the generated parser (`src/parser.c`), which is required for
  # compilation. Only the release tarball ships it.
  # https://github.com/DerekStride/tree-sitter-sql#readme
  src = fetchurl {
    url = "https://github.com/DerekStride/tree-sitter-sql/releases/download/v${finalAttrs.version}/tree-sitter-sql-v${finalAttrs.version}.tar.gz";
    hash = "sha256-TBwDF9ROrqEB834V8y9M5J/gYYVkJVj7pM7Fa3xMb3o=";
  };

  sourceRoot = ".";

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_sql" ];

  nativeCheckInputs = [
    pytestCheckHook
    tree-sitter
  ];

  meta = {
    description = "Sql grammar for tree-sitter";
    homepage = "https://github.com/DerekStride/tree-sitter-sql";
    changelog = "https://github.com/DerekStride/tree-sitter-sql/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
})
