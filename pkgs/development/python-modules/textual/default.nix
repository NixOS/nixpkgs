{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  markdown-it-py,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  rich,
  syrupy,
  time-machine,
  tree-sitter,
  tree-sitter-languages,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.72.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual";
    rev = "refs/tags/v${version}";
    hash = "sha256-iNl9bos1GBLmHRvSgqYD8b6cptmmMktXkDXQbm3xMtc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    rich
    typing-extensions
  ] ++ markdown-it-py.optional-dependencies.plugins ++ markdown-it-py.optional-dependencies.linkify;

  optional-dependencies = {
    syntax = [
      tree-sitter
      tree-sitter-languages
    ];
  };

  nativeCheckInputs = [
    jinja2
    pytest-aiohttp
    pytestCheckHook
    syrupy
    time-machine
    tree-sitter
  ];

  disabledTestPaths = [
    # Snapshot tests require syrupy<4
    "tests/snapshot_tests/test_snapshots.py"
  ];

  disabledTests = [
    # Assertion issues
    "test_textual_env_var"

    # Requirements for tests are not quite ready
    "test_register_language"
    "test_language_binary_missing"
  ];

  pythonImportsCheck = [ "textual" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    changelog = "https://github.com/Textualize/textual/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
