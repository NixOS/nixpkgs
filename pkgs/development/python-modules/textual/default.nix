{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  markdown-it-py,
  poetry-core,
  pytest-aiohttp,
  pytest-xdist,
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
  version = "0.75.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual";
    rev = "refs/tags/v${version}";
    hash = "sha256-lGf7kGqQfddIyFOUdm/L1rZW9O6rZCLi6HXwI84YZDc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    rich
    typing-extensions
  ] ++ markdown-it-py.optional-dependencies.plugins ++ markdown-it-py.optional-dependencies.linkify;

  optional-dependencies = {
    syntax = [ tree-sitter ] ++ lib.optionals (pythonOlder "3.12") [ tree-sitter-languages ];
  };

  nativeCheckInputs = [
    jinja2
    pytest-aiohttp
    pytest-xdist
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
    maintainers = with maintainers; [ joelkoen ];
  };
}
