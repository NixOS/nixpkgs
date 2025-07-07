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
  tree-sitter-markdown,
  tree-sitter-python,
}:

buildPythonPackage rec {
  pname = "textual";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual";
    tag = "v${version}";
    hash = "sha256-zgDzsPSzwwZSgQINcZgFHXNHzEeNvsFMi6C9LBRffHY=";
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
    tree-sitter-markdown
    tree-sitter-python
  ];

  disabledTestPaths = [
    # Snapshot tests require syrupy<4
    "tests/snapshot_tests/test_snapshots.py"
  ];

  disabledTests = [
    # Assertion issues
    "test_textual_env_var"

    # Fail since tree-sitter-markdown was updated to 0.5.0
    # ValueError: Incompatible Language version 15. Must be between 13 and 14
    # https://github.com/Textualize/textual/issues/5868
    "test_setting_builtin_language_via_attribute"
    "test_setting_builtin_language_via_constructor"
  ];

  pytestFlagsArray = [
    # Some tests in groups require state from previous tests
    # See https://github.com/Textualize/textual/issues/4924#issuecomment-2304889067
    "--dist=loadgroup"
  ];

  pythonImportsCheck = [ "textual" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    changelog = "https://github.com/Textualize/textual/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gepbird ];
  };
}
