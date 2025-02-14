{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  markdown-it-py,
  platformdirs,
  rich,
  typing-extensions,

  # optional-dependencies
  tree-sitter,
  tree-sitter-languages,

  # tests
  jinja2,
  pytest-aiohttp,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  time-machine,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "textual";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual";
    tag = "v${version}";
    hash = "sha256-3pNUDkkq9X3W9DdWp4M4h4ddHN+GzUxLCFNJJdAtRJM=";
  };

  build-system = [ poetry-core ];

  dependencies =
    [
      markdown-it-py
      platformdirs
      rich
      typing-extensions
    ]
    ++ markdown-it-py.optional-dependencies.plugins
    ++ markdown-it-py.optional-dependencies.linkify;

  optional-dependencies = {
    syntax = [
      tree-sitter
    ] ++ lib.optionals (!tree-sitter-languages.meta.broken) [ tree-sitter-languages ];
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

    # Flaky: https://github.com/Textualize/textual/issues/5511
    # RuntimeError: There is no current event loop in thread 'MainThread'.
    "tests/test_focus.py"
  ];

  disabledTests =
    [
      # Assertion issues
      "test_textual_env_var"

      # Requirements for tests are not quite ready
      "test_register_language"

      # Requires python bindings for tree-sitter languages
      # https://github.com/Textualize/textual/issues/5449
      "test_setting_unknown_language"
      "test_update_highlight_query"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/Textualize/textual/issues/5327
      "test_cursor_page_up"
      "test_cursor_page_down"
    ];

  # Some tests in groups require state from previous tests
  # See https://github.com/Textualize/textual/issues/4924#issuecomment-2304889067
  pytestFlagsArray = [ "--dist=loadgroup" ];

  pythonImportsCheck = [ "textual" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    changelog = "https://github.com/Textualize/textual/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gepbird ];
  };
}
