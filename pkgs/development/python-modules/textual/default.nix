{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, jinja2
, markdown-it-py
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, rich
, syrupy
, time-machine
, tree-sitter
, typing-extensions
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.40.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+3bxc0ryHtbEJkB+EqjJhW+yWJWxMkxlSav4v6D3/gw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    importlib-metadata
    markdown-it-py
    rich
    typing-extensions
  ] ++ markdown-it-py.optional-dependencies.plugins
    ++ markdown-it-py.optional-dependencies.linkify;

  passthru.optional-dependencies = {
    syntax = [
      tree-sitter
      # tree-sitter-languages
    ];
  };

  nativeCheckInputs = [
    jinja2
    pytest-aiohttp
    pytestCheckHook
    syrupy
    time-machine
  ] ++ passthru.optional-dependencies.syntax;

  disabledTestPaths = [
    # snapshot tests require syrupy<4
    "tests/snapshot_tests/test_snapshots.py"
  ];

  disabledTests = [
    # Assertion issues
    "test_textual_env_var"
    "test_softbreak_split_links_rendered_correctly"

    # requires tree-sitter-languages which is not packaged in nixpkgs
    "test_register_language"
  ];

  pythonImportsCheck = [
    "textual"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    changelog = "https://github.com/Textualize/textual/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
