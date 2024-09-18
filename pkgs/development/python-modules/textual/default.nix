{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  markdown-it-py,
  platformdirs,
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
  version = "0.79.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual";
    rev = "refs/tags/v${version}";
    hash = "sha256-QD9iRgl6hwlFL5DLYyXL5aA/Xsvpe5/KXdEdMS+3L/8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    platformdirs
    markdown-it-py
    rich
    typing-extensions
  ] ++ markdown-it-py.optional-dependencies.plugins ++ markdown-it-py.optional-dependencies.linkify;

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
  ];

  disabledTests = [
    # Assertion issues
    "test_textual_env_var"

    # Requirements for tests are not quite ready
    "test_register_language"
    "test_language_binary_missing"
  ];

  # Some tests in groups require state from previous tests
  # See https://github.com/Textualize/textual/issues/4924#issuecomment-2304889067
  pytestFlagsArray = [ "--dist=loadgroup" ];

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
