{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, mkdocs-exclude
, markdown-it-py
, mdit-py-plugins
, linkify-it-py
, importlib-metadata
, rich
, typing-extensions
, aiohttp
, click
, jinja2
, msgpack
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, syrupy
, time-machine
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.27.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ag+sJFprYW3IpH+BiMR5eSRUFMBeVuOnF6GTTuXGBHw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    rich
    markdown-it-py
    mdit-py-plugins
    linkify-it-py
    importlib-metadata
    aiohttp
    click
    msgpack
    mkdocs-exclude
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
