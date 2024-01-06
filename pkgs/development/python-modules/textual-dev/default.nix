{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, msgpack
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, textual
, time-machine
, typing-extensions
}:

buildPythonPackage rec {
  pname = "textual-dev";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual-dev";
    rev = "refs/tags/v${version}";
    hash = "sha256-66LcU9xXNWzoYV7ykbbKGO3/0URDu/GN2dmtxu1joqw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    msgpack
    textual
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [
    "textual_dev"
  ];

  meta = with lib; {
    description = "Development tools for Textual";
    homepage = "https://github.com/Textualize/textual-dev";
    license = licenses.mit;
    maintainers = with maintainers; [ yannip ];
  };
}
