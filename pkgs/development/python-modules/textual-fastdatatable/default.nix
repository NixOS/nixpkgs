{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pyarrow,
  textual,
  typing-extensions,

  # optional-dependencies
  polars,

  # tests
  pytest-asyncio,
  pytest-textual-snapshot,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-fastdatatable";
  version = "0.19.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-fastdatatable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o+lM682bLwhirNMOJ4AXzdgaA1ggysBkWFnDqTOj1s0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyarrow
    textual
    typing-extensions
  ]
  ++ textual.optional-dependencies.syntax;

  optional-dependencies = {
    polars = [ polars ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-textual-snapshot
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "textual_fastdatatable" ];

  disabledTestPaths = [
    # Tests are comparing CLI output
    "tests/snapshot_tests/test_snapshots.py"
  ];

  meta = {
    description = "Performance-focused reimplementation of Textual's DataTable widget, with a pluggable data storage backend";
    homepage = "https://github.com/tconbeer/textual-fastdatatable";
    changelog = "https://github.com/tconbeer/textual-fastdatatable/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
})
