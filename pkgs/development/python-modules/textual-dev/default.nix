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
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual-dev";
    tag = "v${version}";
    hash = "sha256-f/tceRELDLONzOVVpbbqa5eiXJ1QzYw3A47R/9EqEU4=";
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
    changelog = "https://github.com/Textualize/textual-dev/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ yannip ];
    mainProgram = "textual";
  };
}
