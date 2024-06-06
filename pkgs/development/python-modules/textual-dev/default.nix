{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  msgpack,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  textual,
  time-machine,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "textual-dev";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual-dev";
    rev = "refs/tags/v${version}";
    hash = "sha256-QnMKVt1WxnwGnZFNb7Gbus7xewGvyG5xJ0hIKKK5hug=";
  };

  nativeBuildInputs = [ poetry-core ];

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

  pythonImportsCheck = [ "textual_dev" ];

  meta = with lib; {
    description = "Development tools for Textual";
    mainProgram = "textual";
    homepage = "https://github.com/Textualize/textual-dev";
    license = licenses.mit;
    maintainers = with maintainers; [ yannip ];
  };
}
