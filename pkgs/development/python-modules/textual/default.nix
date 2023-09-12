{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, importlib-metadata
, jinja2
, linkify-it-py
, markdown-it-py
, mdit-py-plugins
, mkdocs-exclude
, msgpack
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, rich
, syrupy
, time-machine
, typing-extensions
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.36.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GH5GhXHA/6r3UNeM4YW+khyh1HnyUQBFcSNFaJwFz9c=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    importlib-metadata
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    mkdocs-exclude
    msgpack
    rich
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  nativeCheckInputs = [
    jinja2
    pytest-aiohttp
    pytestCheckHook
    syrupy
    time-machine
  ];

  disabledTestPaths = [
    # snapshot tests require syrupy<4
    "tests/snapshot_tests/test_snapshots.py"
  ];

  disabledTests = [
    # Assertion issues
    "test_textual_env_var"
    "test_softbreak_split_links_rendered_correctly"
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
