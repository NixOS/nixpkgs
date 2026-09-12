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
  version = "0.3.11";
  pyproject = true;
  __structuredAttrs = true;

  # The git tree does not contain the generated parser (`src/parser.c`), which is required for
  # compilation. Only the release tarball ships it.
  # https://github.com/DerekStride/tree-sitter-sql#readme
  src = fetchurl {
    url = "https://github.com/DerekStride/tree-sitter-sql/releases/download/v${finalAttrs.version}/tree-sitter-sql-v${finalAttrs.version}.tar.gz";
    hash = "sha256-qXoyTq6cge1o9uFiubM/iRH8ZELKopUOV8SY4kYNE4c=";
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
