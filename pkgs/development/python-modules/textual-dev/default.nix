{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  click,
  msgpack,
  textual,
  textual-serve,
  typing-extensions,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "textual-dev";
  version = "1.7.0";
  pyproject = true;

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
    textual-serve
    typing-extensions
  ];

  # Tests require a running textual WS server
  doCheck = false;

  pythonImportsCheck = [ "textual_dev" ];

  meta = {
    description = "Development tools for Textual";
    homepage = "https://github.com/Textualize/textual-dev";
    changelog = "https://github.com/Textualize/textual-dev/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yannip ];
    mainProgram = "textual";
  };
}
