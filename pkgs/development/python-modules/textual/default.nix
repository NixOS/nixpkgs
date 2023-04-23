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
  version = "0.15.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UT+ApD/TTb5cxIdgK+n3B2J3z/nEwVXtuyPHpGCv6Tg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'importlib-metadata = "^4.11.3"' 'importlib-metadata = "*"'
  '';

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

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
