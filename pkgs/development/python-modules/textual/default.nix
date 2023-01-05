{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, importlib-metadata
, nanoid
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
  version = "0.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-a32H5X3VsfYuU1TkOH5uGn1eDLvGUDI6WhXEQ0AKwq8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'importlib-metadata = "^4.11.3"' 'importlib-metadata = "*"'
  '';

  propagatedBuildInputs = [
    importlib-metadata
    nanoid
    rich
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [
    aiohttp
    click
    jinja2
    msgpack
    pytest-aiohttp
    pytestCheckHook
    syrupy
    time-machine
  ];

  pythonImportsCheck = [
    "textual"
  ];

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
