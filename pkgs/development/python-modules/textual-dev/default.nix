{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  msgpack,
  poetry-core,
  pythonOlder,
  textual,
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

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    msgpack
    textual
    typing-extensions
  ];

  # Tests require a running textual WS server
  doCheck = false;

  pythonImportsCheck = [ "textual_dev" ];

  meta = with lib; {
    description = "Development tools for Textual";
    homepage = "https://github.com/Textualize/textual-dev";
    changelog = "https://github.com/Textualize/textual-dev/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ yannip ];
    mainProgram = "textual";
  };
}
